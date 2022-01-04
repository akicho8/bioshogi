# frozen-string-literal: true
module Bioshogi
  class PresetInfo
    include ApplicationMemoryRecord
    # special_piece: 大駒があるか？
    memory_record [
      { key: "平手",           handicap: false, special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "香落ち",         handicap: true,  special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "右香落ち",       handicap: true,  special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "角落ち",         handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "飛車落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "飛香落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "二枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      # { key: "二枚持ち",       handicap: true,  special_piece: false, piece_boxes: { black: "飛角",   white: "",       }, }, # これは盤の情報から逆算できない。「二枚落ち」と判定されてしまうため、根本的にロジックを変更しないといけない。
      { key: "三枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, }, # 1849/03/15 伊藤宗印 vs 天満屋 の手合割にある
      { key: "四枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "六枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "トンボ",         handicap: true,  special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "八枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "十枚落ち",       handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "十九枚落ち",     handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "二十枚落ち",     handicap: true,  special_piece: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "青空将棋",       handicap: false, special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "バリケード将棋", handicap: false, special_piece: true,  piece_boxes: { black: "飛角香", white: "飛角香", }, },
      { key: "5五将棋",        handicap: false, special_piece: true,  piece_boxes: { black: "",       white: "",       }, },
    ]

    class << self
      def lookup(key)
        key = key.to_s
        key = key.sub(/[5５五][5５五々]/, "5五") # 五々将棋 -> 5五将棋
        key = key.sub(/(.)車/, '\1')             # 飛車 香車 -> 飛 香
        key = key.sub(/飛落/, "飛車落")
        key = key.sub(/裸玉/, "十九枚落ち")
        key = key.sub(/詰将棋/, "平手")
        key = key.sub(/落\z/, "落ち")            # 香落 -> 香落ち
        super
      end

      # 持駒の比較は別途行う必要あり
      def lookup_by_soldiers(soldiers, optimize: true)
        if optimize
          # 盤上の駒数で瞬時に比較すれば全体と比較する必要はなくなり速くなるかと思ったが誤差だった
          @lookup_by_soldiers ||= group_by { |e| e.shape_info.board_parser.soldiers.count }
          if list = @lookup_by_soldiers[soldiers.count]
            sorted_soldiers = soldiers.sort
            list.find do |e|
              sorted_soldiers == e.sorted_soldiers
            end
          end
        else
          sorted_soldiers = soldiers.sort
          PresetInfo.find do |e|
            sorted_soldiers == e.sorted_soldiers
          end
        end
      end
    end

    def to_sfen
      mediator = Mediator.new
      mediator.placement_from_preset(key)
      mediator.turn_info.handicap = handicap
      mediator.to_snapshot_sfen
    end

    def to_position_sfen
      to_sfen
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

    # 平手と比べてどこの駒が足りないかがわかる
    # PresetInfo["二枚落ち"].declined_soldiers.collect(&:to_s) # => ["△８二飛", "△２二角"]
    def declined_soldiers
      @declined_soldiers ||= self.class.fetch("平手").sorted_soldiers - sorted_soldiers
    end

    def handicap_shift
      handicap ? 1 : 0
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
