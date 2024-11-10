# frozen-string-literal: true
#
#    ９ ８ ７ ６ ５ ４ ３ ２ １
#  +---------------------------+
#  | ・v桂v銀v金v玉v金v銀v桂v香|一
#  | ・v飛 ・ ・ ・ ・ ・v角 ・|二
#  |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
#  | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
#  | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
#  | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
#  | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
#  | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
#  | 香 桂 銀 金 玉 金 銀 桂 香|九
#  +---------------------------+
#
module Bioshogi
  module Board
    class KakinokiFormatter
      def initialize(board)
        @board = board
      end

      def to_s
        [header, line, *rows, line].join("\n") + "\n"
      end

      private

      def header
        "  " + Dimension::DimensionColumn.dimension_size.times.collect { |i| Dimension::DimensionColumn.fetch(i).name }.join(" ")
      end

      def line
        "+" + "---" * Dimension::DimensionColumn.dimension_size + "+"
      end

      def rows
        Dimension::DimensionRow.dimension_size.times.collect do |y|
          fields = Dimension::DimensionColumn.dimension_size.times.collect do |x|
            place = Place.fetch([x, y])
            soldier = @board.surface[place]
            cell_str(soldier)
          end
          "|" + fields.join + "|" + Dimension::DimensionRow.fetch(y).name
        end
      end

      def cell_str(object)
        if object
          object.to_bod
        else
          " " + "・"
        end
      end
    end
  end
end
