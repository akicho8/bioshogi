# frozen-string-literal: true

module Bioshogi
  module Parser
    class CsaParser < Base
      SYSTEM_COMMENT_CHAR = "'"
      KEY_VALUE_REGEXP = /^(N[+-]|\$\w+:)(.*)$/

      # 将棋ウォーズの時間はバグっていてマイナスの時間になることがあるため T-123 形式も考慮する。
      # ただし、これを最後まで許容すると KIF の時間もマイナス表記になり、KENTOが読み込みに失敗する。
      # いまは MainClock クラスの add でチェックしてしかたなくマイナスにならないようにしている。
      TIME_REGEXP = /[A-Z]([+-]?\d+)/

      # 指し手
      MOVE_REGEXP = /^([+-]?\d+\w+)\R+(?:#{TIME_REGEXP})?/

      class << self
        def accept?(source)
          str = Source.wrap(source).to_s
          v = false
          v ||= str.match?(/^\s*\b(V\d+\.\d+)\b/)  # V2.2 '# Kifu for iPhone V4.01 棋譜ファイル' の V4.01 がひっかかってしまうため ^\s* を入れるの重要
          v ||= str.match?(/\b(PI|P\d|P[\+\-])\b/) # PI P1 P+ P-
          v ||= str.match?(/[+-]\d{4}[A-Z]{2}/)    # +1828OU
          v ||= str.match?(/\b(N[+-])\b/)          # 対局者名
        end
      end

      def parse
        key_value_store

        case1_PI
        case2_P1
        case3_Psign

        guess_preset

        read_turn
        read_moves
        read_last

        pi.header.normalize
      end

      private

      def normalized_source
        @normalized_source ||= Source.wrap(@source).to_s.yield_self do |s|
          s = s.gsub(/^#{SYSTEM_COMMENT_CHAR}.*/o, "")  # コメント行の削除
          s = s.gsub(/,/, "\n")                         # カンマは改行と見なす
        end
      end

      # ヘッダーっぽいのもを収集
      def key_value_store
        normalized_source.scan(KEY_VALUE_REGEXP) do |key, value|
          # キーをKIF側に統一
          if e = CsaHeaderInfo[key]
            key = e.kif_side_key
          end
          # ヘッダー情報が重複した場合は最初に出てきたものを優先
          pi.header[key] ||= value
        end
      end

      ################################################################################ (1)
      # > (1) 平手初期配置と駒落ち
      # > 平手初期配置は、"PI"とする。駒落ちは、"PI"に続き、落とす駒の位置と種類を必要なだけ記述する。
      # > 例:二枚落ち PI82HI22KA
      def case1_PI
        if md = normalized_source.match(/^PI(?<handicap_piece_list>.*)/)
          @board = Board.new
          @board.placement_from_preset("平手")
          if v = md[:handicap_piece_list]
            v.scan(/(\d+)(\D+)/i) do |xy, piece_key|
              place = Place.fetch(xy)
              piece = Piece.fetch(piece_key)
              soldier = @board.fetch(place)
              if soldier.piece != piece
                raise SyntaxDefact, "#{v}として#{place}#{piece.name}を落とす指定がありましたがそこにある駒は#{soldier.any_name}です"
              end
              @board.safe_delete_on(soldier.place)
            end
          end
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
      def case2_P1
        if normalized_source.match?(/^P\d/)
          if @board
            raise SyntaxDefact, "1行表現の PI と、複数行一括表現の P1 の定義が干渉しています"
          end
          str = normalized_source.scan(/^P\d.*\n/).join

          @board = Board.new
          @board.placement_from_shape(str)
        end
      end

      ################################################################################ (3)
      # > (3) 駒別単独表現
      # > 一つ一つの駒を示すときは、先後の区別に続き、位置と駒の種類を記述する。持駒に限り、駒の種類として"AL"が使用でき、残りの駒すべてを表す。駒台は"00"である。
      # > 玉は、駒台へはいかない。
      #
      # P-51OU        …… 後手 ５一玉          を配置
      # P+53KI00GI    …… 先手 ５三金 駒台に銀 を配置
      # P-00AL        …… 後手 残りすべての駒を駒台に配置
      #
      # NOTE: (2)の一括表現と(3)の駒別単独表現は共存する
      # ドキュメントにはこのあたりの言及がなかったため @pi.board_source がすでにあればスキップしていたが
      # 詰将棋などではここで持駒を調整される
      def case3_Psign
        if normalized_source.match?(/^P[\+\-](.*)/)
          # この時点で盤が用意されていなかったら空の盤を用意する
          unless @board
            @board = Board.new
          end

          # 駒箱
          piece_box = PieceBox.real_box

          # 両者の駒台
          hold_pieces = Location.inject({}) { |a, e| a.merge(e => []) }

          normalized_source.scan(/^P([\+\-])(.*)$/) do |location_key, piece_list|
            location = Location.fetch(location_key)
            piece_list.scan(/(\d+)(\D+)/i) do |xy, piece_ch|
              if piece_ch == "AL"
                if xy != "00"
                  raise SyntaxDefact, "AL が指定されているのに座標が 00 になっていません"
                end
                # 残りすべてを駒台に置く
                hold_pieces[location] += piece_box.pick_out_without_king
              else
                attrs = Soldier.piece_and_promoted(piece_ch)
                # 駒箱から取り出す
                piece = piece_box.pick_out(attrs[:piece])
                if xy == "00"
                  # 駒台に置く
                  hold_pieces[location] << piece
                else
                  # 盤に置く
                  # if @pi.board_source
                  #   raise SyntaxDefact, "P#{location_key}#{xy}#{piece_ch} としましたがすでに、PI か P1 表記で盤面の指定があります。無駄にややこしくなるので PI P1 P+59OU 表記を同時に使わないでください"
                  # end
                  soldier = Soldier.create(attrs.merge(location: location, place: Place.fetch(xy)))
                  @board.place_on(soldier, validate: true)
                end
              end
            end
          end

          hold_pieces.each do |location, pieces|
            pi.player_piece_boxes[location.key].set(Piece.a_to_h(pieces))
          end
        end
      end

      def guess_preset
        if @board
          @pi.board_source = @board.to_s # FIXME: 元に戻すのは無駄
          if e = @board.preset_info
            @pi.force_preset_info = e
          end
        end
      end

      def read_turn
        if md = normalized_source.match(/^(?<csa_sign>[+-])$/)
          if Location.fetch(md["csa_sign"]).key == :white
            @pi.force_handicap = true # 微妙な判定
          end
        end
      end

      def read_moves
        @pi.move_infos += normalized_source.scan(MOVE_REGEXP).collect do |input, n|
          if n
            n = n.to_i.seconds
          end
          { input: input, used_seconds: n }
        end
      end

      def read_last
        if md = normalized_source.match(/^%(?<last_action_key>\S+)(\R+[A-Z](?<used_seconds>(\d+)))?/)
          @pi.last_action_info = LastActionInfo.fetch(md[:last_action_key])
          if v = md[:used_seconds]
            @pi.last_used_seconds = v.to_i.seconds
          end
        end
      end
    end
  end
end
