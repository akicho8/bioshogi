# frozen-string-literal: true

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

module Warabi
  class KakikiBoardFormater
    def initialize(board)
      @board = board
    end

    def to_s
      [header, line, *rows, line].join("\n") + "\n"
    end

    private

    def header
      "  " + Position::Hpos.units.join(" ")
    end

    def line
      "+" + "---" * Position::Hpos.dimension + "+"
    end

    def rows
      Position::Vpos.dimension.times.collect do |y|
        fields = Position::Hpos.dimension.times.collect do |x|
          point = Point.fetch([x, y])
          object_to_s(@board[point])
        end
        "|" + fields.join + "|" + Position::Vpos.fetch(y).name
      end
    end

    def object_to_s(object)
      if object
        object.to_kif
      else
        " " + "・"
      end
    end
  end
end
