# frozen-string-literal: true
module Bioshogi
  class PresetInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: "平手",       handicap: false, special_piece: true, },
      {key: "香落ち",     handicap: true,  special_piece: true, },
      {key: "右香落ち",   handicap: true,  special_piece: true, },
      {key: "角落ち",     handicap: true,  special_piece: false, },
      {key: "飛車落ち",   handicap: true,  special_piece: false, },
      {key: "飛香落ち",   handicap: true,  special_piece: false, },
      {key: "二枚落ち",   handicap: true,  special_piece: false, },
      {key: "三枚落ち",   handicap: true,  special_piece: false, }, # 1849/03/15 伊藤宗印 vs 天満屋 の手合割にある
      {key: "四枚落ち",   handicap: true,  special_piece: false, },
      {key: "六枚落ち",   handicap: true,  special_piece: false, },
      {key: "八枚落ち",   handicap: true,  special_piece: false, },
      {key: "十枚落ち",   handicap: true,  special_piece: false, },
      {key: "十九枚落ち", handicap: true,  special_piece: false, },
      {key: "二十枚落ち", handicap: true,  special_piece: false, },
    ]

    class << self
      def lookup(key)
        key = key.to_s
        key = key.gsub(/(.)車/, '\1') # (飛|香)車 -> 飛|香
        key = key.gsub(/飛落/, '飛車落')
        key = key.gsub(/裸玉/, "十九枚落ち")
        super
      end
    end

    def to_sfen
      mediator = Mediator.new
      mediator.placement_from_preset(key)
      mediator.turn_info.handicap = handicap
      mediator.to_long_sfen
    end

    def to_position_sfen
      "position #{to_sfen}"
    end

    def to_board
      Board.new.tap do |e|
        e.placement_from_preset(key)
      end
    end

    # 手合を元に手番を得る
    def to_turn_info
      TurnInfo.new(handicap: handicap)
    end

    # 格式の高さ(ソート用)
    def formal_level
      self.class.count - code
    end

    concerning :DelegateToShapeInfoMethods do
      included do
        delegate :board_parser, :location_split, :sorted_soldiers, to: :shape_info
      end

      def shape_info
        ShapeInfo.lookup(key)
      end
    end
  end
end
