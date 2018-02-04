# frozen-string-literal: true
module Bushido
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
            source.match?(/^V\d+\.\d+/)         ||
            source.match?(/^(PI|P\d)/)          ||
            source.match?(/^[+-]\d{4}[A-Z]{2}/) ||
            source.match?(/^N[+-]/)             ||
            false
        end
      end

      def parse
        s = normalized_source

        # コメント行の削除
        s = s.gsub(/^#{comment_char}.*/o, "")

        # カンマは改行と見なす
        s = s.gsub(/,/, "\n")

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

        # P1 形式の盤面の読み取り
        @board_source = s.scan(/^P\d.*\n/).join.presence

        # P1 形式でなければ PI82HI22KA 形式として読み取り
        unless @board_source
          if md = s.match(/^PI(?<komaochi_piece_list>.*)/)
            mediator = Mediator.new
            mediator.board_reset("平手")
            if v = md[:komaochi_piece_list]
              v.scan(/(\d+)(\D+)/i) do |xy, piece_key|
                point = Point.fetch(xy)
                piece = Piece.fetch(piece_key)
                battler = mediator.board.surface.fetch(point)
                if battler.piece != piece
                  raise SyntaxDefact, "#{point.name}の#{piece.name}を落とす指定がありましたがそこにある駒は#{battler.piece.name}です : #{v.inspect}"
                end
                battler.abone
              end
            end
            @board_source = mediator.board.to_s
          end
        end

        # 棋譜
        @move_infos += s.scan(/^([+-]?\d+\w+)\R+(?:[A-Z](\d+))?/).collect do |input, used_seconds|
          if used_seconds
            used_seconds = used_seconds.to_i
          end
          {input: input, used_seconds: used_seconds}
        end

        if md = s.match(/^%(?<last_action_key>\S+)(\R+[A-Z](?<used_seconds>(\d+)))?/)
          @last_status_params = md.named_captures.symbolize_keys
        end
      end
    end
  end
end
