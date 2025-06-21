# frozen-string-literal: true

# |-------------+--------------------------------------+----------------------------------------------------------|
# | 属性        | 意味                                 | 備考                                                     |
# |-------------+--------------------------------------+----------------------------------------------------------|
# | hirate_like | ほぼ平手の配置か？                   |                                                          |
# | minor       | 一般的なソフトが対応してないものか？ | 「手合割：トンボ」などと表記すると一般的なソフトはバグる |
# | handicap    | △が初手を指すか？                   |                                                          |
# | x_taden     | 銀多伝・金多伝を許可するか？         |                                                          |
# |-------------+--------------------------------------+----------------------------------------------------------|

module Bioshogi
  class PresetInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "平手",           major: true,  handicap: false, hirate_like: true,  x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "香落ち",         major: true,  handicap: true,  hirate_like: true,  x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "右香落ち",       major: false, handicap: true,  hirate_like: true,  x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "角落ち",         major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "飛車落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "飛香落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "二枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "二枚持ち",       major: false, handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "飛角",   white: "",       }, }, # これは盤の情報から逆算できない。「二枚落ち」と判定されてしまうため、根本的にロジックを変更しないといけない。
      { key: "三枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, }, # 1849/03/15 伊藤宗印 vs 天満屋 の手合割にある
      { key: "四枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "六枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: true,  piece_boxes: { black: "",       white: "",       }, },
      { key: "トンボ",         major: false, handicap: true,  hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "八枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "十枚落ち",       major: true,  handicap: true,  hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "十九枚落ち",     major: false, handicap: true,  hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "二十枚落ち",     major: false, handicap: true,  hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "青空将棋",       major: false, handicap: false, hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
      { key: "バリケード将棋", major: false, handicap: false, hirate_like: false, x_taden: false, piece_boxes: { black: "飛角香", white: "飛角香", }, },
      { key: "5五将棋",        major: false, handicap: false, hirate_like: false, x_taden: false, piece_boxes: { black: "",       white: "",       }, },
    ]

    class << self
      def lookup(key)
        key = key.to_s
        key = key.sub(/[5５五][5５五々]/, "5五") # 五々将棋 -> 5五将棋
        key = key.sub(/(.)車/, '\1')             # 飛車 香車 -> 飛 香
        key = key.sub(/飛落/, "飛車落")
        key = key.sub(/詰将棋/, "平手")
        key = key.sub(/落\z/, "落ち")            # 香落 -> 香落ち
        super
      end

      # 一般的なものに絞る
      def major_only
        @major_only ||= find_all(&:major)
      end

      # 一般的でないものに絞る
      def minor_only
        @minor_only ||= reject(&:major)
      end

      # 持駒の比較は別途行う必要あり
      def lookup_by_soldiers(soldiers, options = {})
        options = {
          :optimize        => false, # 速くなる (気がするだけでほとんど効果がない)
          :inclusion_minor => false, # トンボなど一般的な名前も含めるか？
        }.merge(options)

        if options[:optimize]
          raise "must not happen"
          # # 盤上の駒数で瞬時に比較すれば全体と比較する必要はなくなり速くなるかと思ったが誤差だった
          # @lookup_by_soldiers ||= yield_self {
          #   list = to_a
          #   if options[:public_name]
          #     list = list.find_all(&:public_name)
          #   end
          #   list.group_by { |e| e.shape_info.board_parser.soldiers.count }
          # }
          # if list = @lookup_by_soldiers[soldiers.count]
          #   sorted_soldiers = soldiers.sort
          #   list.find do |e|
          #     sorted_soldiers == e.sorted_soldiers
          #   end
          # end
        else
          sorted_soldiers = soldiers.sort
          if options[:inclusion_minor]
            list = to_a
          else
            list = major_only
          end
          list.find { |e| sorted_soldiers == e.sorted_soldiers }
        end
      end
    end

    def to_sfen
      container = Container::Basic.new
      container.placement_from_preset(key)
      container.turn_info.handicap = handicap
      container.to_short_sfen
    end

    def to_short_sfen
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

    include Analysis::ShapeInfoRelation
  end
end
