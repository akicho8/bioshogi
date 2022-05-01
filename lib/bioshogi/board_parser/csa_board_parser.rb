# frozen-string-literal: true

module Bioshogi
  module BoardParser
    # P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
    # P2 * -HI *  *  *  *  * -KA *
    # P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
    # P4 *  *  *  *  *  *  *  *  *
    # P5 *  *  *  *  *  *  *  *  *
    # P6 *  *  *  *  *  *  *  *  *
    # P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
    # P8 * +KA *  *  *  *  * +HI *
    # P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
    class CsaBoardParser < Base
      def self.accept?(source)
        source && source.match?(/\b(P\d+)\b/)
      end

      def parse
        shape_lines.each do |line|
          if md = line.match(/P(?<y>\d+)\s*(?<cells>.*)\s*/) # strip 代わりに cells の両方を \s* している
            y = md[:y]

            # 空白または * の文字を 1..3 とすることで行末スペースの有無に依存しなくなる
            # この方法では次のようにスペースが潰れている場合に失敗する
            # P1 * -HI * * * * * -KA *
            # cells = md[:cells].scan(/\S{3}|[\s\*]{1,3}/)

            # 改良した方法
            # " " または +- の直前で分離する
            cells = md[:cells].split(/\s+|(?=[+-])/)

            cells.reverse_each.with_index(1) do |e, x|
              if md = e.match(/(?<csa_sign>\S)(?<piece>\S{2})/)
                location_info = LocationInfo[md[:csa_sign]]
                place = Place["#{x}#{y}"]
                soldiers << Soldier.new_with_promoted(md[:piece], place: place, location_info: location_info)
              end
            end
          end
        end
      end
    end
  end
end
