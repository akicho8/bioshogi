# frozen-string-literal: true
module Warabi
  class PresetInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: "平手",       },
      {key: "香落ち",     },
      {key: "右香落ち",   },
      {key: "角落ち",     },
      {key: "飛車落ち",   },
      {key: "飛車香落ち", },
      {key: "二枚落ち",   },
      {key: "三枚落ち",   }, # 1849/03/15 伊藤宗印 vs 天満屋 の手合割にある
      {key: "四枚落ち",   },
      {key: "六枚落ち",   },
      {key: "八枚落ち",   },
      {key: "十枚落ち",   },
      {key: "十九枚落ち", },
      {key: "二十枚落ち", },
    ]

    class << self
      def lookup(key)
        key = key.to_s
        key = key.gsub(/飛([^車])/, '飛車\1')
        key = key.gsub(/香車/, "香")
        key = key.gsub(/裸玉/, "十九枚落ち")
        super
      end
    end

    concerning :DelegateToShapeInfoMethods do
      included do
        delegate :board_parser, :both_board_info, :sorted_black_side_soldiers, :black_side_soldiers, :sorted_soldiers, to: :shape_info
      end

      def shape_info
        ShapeInfo.fetch(key)
      end
    end
  end
end
