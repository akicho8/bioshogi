# frozen-string-literal: true

module Bushido
  # kif形式詳細 (1) - 勝手に将棋トピックス http://d.hatena.ne.jp/mozuyama/20030909/p5
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
  class KakikiFormat
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
      "+" + "---" * Position::Hpos.board_size + "+"
    end

    def rows
      Position::Vpos.board_size.times.collect do |y|
        fields = Position::Hpos.board_size.times.collect do |x|
          object_to_s(@board.surface[[x, y]])
        end
        "|#{fields.join}|" + Position::Vpos.parse(y).name
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
