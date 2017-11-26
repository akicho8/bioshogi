# -*- frozen-string-literal: false -*-

module Bushido
  # P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
  # P2 * -HI *  *  *  *  * -KA *
  # P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
  # P4 *  *  *  *  *  *  *  *  *
  # P5 *  *  *  *  *  *  *  *  *
  # P6 *  *  *  *  *  *  *  *  *
  # P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
  # P8 * +KA *  *  *  *  * +HI *
  # P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
  class CsaBoardFormat
    def initialize(board)
      @board = board
    end

    def to_s
      rows.join
    end

    private

    def rows
      Position::Vpos.size.times.collect do |y|
        "P#{y.next}" + Position::Hpos.size.times.collect { |x|
          object_to_s(@board.surface[[x, y]])
        }.join + "\n"
      end
    end

    def object_to_s(object)
      if object
        object.to_csa
      else
        " * "
      end
    end
  end
end
