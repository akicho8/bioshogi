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
      class << self
        def accept?(source)
          source = Parser.source_normalize(source)
          source.match?(/^(V\d+|PI|P\d)/) || source.match?(/^V\d+/)
        end
      end

      def parse
        s = normalized_source

        # コメント行の削除
        s = s.gsub(/^'.*/, "")

        # カンマは改行と見なす
        s = s.gsub(/,/, "\n")

        # ヘッダーっぽいのもを収集
        s.scan(/^(N[+-]|\$\w+:)(.*)\n/) do |key, value|
          if e = HeaderInfo[key]
            key = e.replace_key
          end
          # ヘッダーの情報を重複した場合は最初に出てきたものを有効にしている
          header[key] ||= value
        end

        # 盤面
        @board_source = s.scan(/^P\d.*\n/).join

        # 棋譜
        s.scan(/^[+-](\d+\w+)\n(?:T(\d+))?/) do |value, time|
          @move_infos << {input: value}
        end
      end
    end
  end
end
