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
  class KakinokiBoardFormatter
    def initialize(board)
      @board = board
    end

    def to_s
      [header, line, *rows, line].join("\n") + "\n"
    end

    private

    def header
      "  " + Dimension::Xplace.units.join(" ")
    end

    def line
      "+" + "---" * Dimension::Xplace.dimension + "+"
    end

    def rows
      Dimension::Yplace.dimension.times.collect do |y|
        fields = Dimension::Xplace.dimension.times.collect do |x|
          place = Place.fetch([x, y])
          soldier_to_str(@board.surface[place])
        end
        "|" + fields.join + "|" + Dimension::Yplace.fetch(y).name
      end
    end

    def soldier_to_str(object)
      if object
        object.to_bod
      else
        " " + "・"
      end
    end
  end
end
