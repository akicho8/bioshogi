# frozen-string-literal: true
module Bioshogi
  module Parser

    # 'encoding=Shift_JIS
    # ' ---- Kifu for Windows V7 V7.31 CSA形式棋譜ファイル ----
    # V2.2
    # N+akicho8
    # N-yosui26
    # $EVENT:レーティング対局室(早指2)
    # $START_TIME:2017/11/15 0:23:44
    # P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
    # P2 * -HI *  *  *  *  * -KA *
    # P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
    # P4 *  *  *  *  *  *  *  *  *
    # P5 *  *  *  *  *  *  *  *  *
    # P6 *  *  *  *  *  *  *  *  *
    # P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
    # P8 * +KA *  *  *  *  * +HI *
    # P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
    # +
    # +7968GI,T5
    # -3334FU,T0
    # %TORYO,T16

    class CsaParser < Base
      cattr_accessor(:comment_char) { "'" }

      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          false ||
            source.match?(/^\s*\b(V\d+\.\d+)\b/)  || # '# Kifu for iPhone V4.01 棋譜ファイル' の V4.01 がひっかかってしまうため ^\s* を入れるの重要
            source.match?(/\b(PI|P\d|P[\+\-])\b/) ||
            source.match?(/[+-]\d{4}[A-Z]{2}/)    ||
            source.match?(/\b(N[+-])\b/)          ||
            false
        end
      end

      def normalized_source
        @normalized_source ||= Parser.source_normalize(@source).yield_self do |s|
          s = s.gsub(/^#{comment_char}.*/o, "")  # コメント行の削除
          s = s.gsub(/,/, "\n")                  # カンマは改行と見なす
        end
      end

      def parse
        s = normalized_source

        # ヘッダーっぽいのもを収集
        s.scan(/^(N[+-]|\$\w+:)(.*)\n/) do |key, value|
          # キーをKIF側に統一
          if e = CsaHeaderInfo[key]
            key = e.kif_side_key
          end

          # ヘッダー情報が重複した場合は最初に出てきたものを優先
          header[key] ||= value
        end
        header_normalize

        ################################################################################ (1)
        # > (1) 平手初期配置と駒落ち
        # > 平手初期配置は、"PI"とする。駒落ちは、"PI"に続き、落とす駒の位置と種類を必要なだけ記述する。
        # > 例:二枚落ちPI82HI22KA

        unless @board_source
          if md = s.match(/^PI(?<handicap_piece_list>.*)/)
            mediator = Mediator.new
            mediator.placement_from_preset("平手")
            if v = md[:handicap_piece_list]
              v.scan(/(\d+)(\D+)/i) do |xy, piece_key|
                place = Place.fetch(xy)
                piece = Piece.fetch(piece_key)
                soldier = mediator.board.fetch(place)
                if soldier.piece != piece
                  raise SyntaxDefact, "#{v}として#{place}#{piece.name}を落とす指定がありましたがそこにある駒は#{soldier.any_name}です"
                end
                mediator.board.safe_delete_on(soldier.place)
              end
            end
            @board_source = mediator.board.to_s
          end
        end

        ################################################################################ (2)
        # > (2) 一括表現
        # > 1行の駒を以下のように示す。行番号に続き、先後の区別と駒の種類を記述する。
        # > 先後の区別が"+""-"以外のとき、駒がないとする。
        # > 1枡3文字で9枡分記述しないといけない。
        # > 例:
        # > P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
        # > P2 * -HI *  *  *  *  * -KA *

        # P1 形式の盤面の読み取り
        unless @board_source
          @board_source = s.scan(/^P\d.*\n/).join.presence
        end

        ################################################################################ (3)
        # > (3) 駒別単独表現
        # > 一つ一つの駒を示すときは、先後の区別に続き、位置と駒の種類を記述する。持駒に限り、駒の種類として"AL"が使用でき、残りの駒すべてを表す。駒台は"00"である。
        # > 玉は、駒台へはいかない。

        # P-51OU        …… 後手 ５一玉          を配置
        # P+53KI00GI    …… 先手 ５三金 駒台に銀 を配置
        # P-00AL        …… 後手 残りすべての駒を駒台に配置

        unless @board_source
          if s.match?(/^P[\+\-](.*)/)
            sub_mediator = Mediator.new

            # 駒箱
            piece_box = PieceBox.new(Piece.s_to_h("歩9角飛香2桂2銀2金2玉" * 2))

            # 両者の駒台
            hold_pieces = Location.inject({}) { |a, e| a.merge(e => []) }

            s.scan(/^P([\+\-])(.*)$/) do |location_key, piece_list|
              location = Location.fetch(location_key)
              piece_list.scan(/(\d+)(\D+)/i) do |xy, piece_ch|
                if piece_ch == "AL"
                  raise SyntaxDefact, "AL が指定されているのに座標が 00 になっていません" if xy != "00"
                  # 残りすべてを駒台に置く
                  hold_pieces[location] += piece_box.pick_out_without_king
                else
                  attrs = Soldier.piece_and_promoted(piece_ch)
                  # 駒箱から取り出す
                  piece = piece_box.pick_out(attrs[:piece])
                  if xy == "00"
                    # 駒台に置く
                    raise SyntaxDefact, "#{piece.name} は駒台に置けません" if piece.key == :king
                    hold_pieces[location] << piece
                  else
                    # 盤に置く
                    soldier = Soldier.create(attrs.merge(location: location, place: Place.fetch(xy)))
                    sub_mediator.board.place_on(soldier)
                  end
                end
              end
            end
            hold_pieces.each do |location, pieces|
              player = sub_mediator.player_at(location)
              header["#{player.call_name}の持駒"] = Piece.a_to_s(pieces)
            end
            @board_source = sub_mediator.board.to_s
          end
        end

        # 手番は見ていない

        # 指し手
        @move_infos += s.scan(/^([+-]?\d+\w+)\R+(?:#{time_regexp})?/o).collect do |input, used_seconds|
          if used_seconds
            used_seconds = used_seconds.to_i
          end
          {input: input, used_seconds: used_seconds}
        end

        if md = s.match(/^%(?<last_action_key>\S+)(\R+[A-Z](?<used_seconds>(\d+)))?/)
          @last_status_params = md.named_captures.symbolize_keys
        end
      end

      # "-" だけの行があれば上手からの開始とする
      def handicap?
        normalized_source.match?(/^\-$/)
      end

      private

      # 時間の部分
      # T123 形式
      # ありえないことだけど将棋ウォーズの時間はバグっていて時間が過去に戻ったりしてマイナスになることがあるため T-123 形式も考慮している
      #
      # 2020-02-13
      # しかし、これを許容すると KIF の時間にマイナスになったりするので問題あり
      # なのでいまは ChessClock クラスの add でチェックしている
      #
      def time_regexp
        /[A-Z]([+-]?\d+)/
      end
    end
  end
end
