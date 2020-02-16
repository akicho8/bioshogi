# frozen-string-literal: true

module Bioshogi
  class TurnInfo
    attr_accessor :turn_base    # 何手の局面か？ 通常は0
    attr_accessor :turn_offset  # 何手から始まっているか関係なく moves のオフセット
    attr_accessor :handicap     # 駒落ちの場合 true にすると先後を調整する

    def initialize(handicap: false, turn_base: nil, turn_offset: nil)
      @handicap = handicap
      @turn_offset = turn_offset || 0
      @turn_base = turn_base || 0
    end

    # 戦法判定や表示するときに用いる手数
    def display_turn
      turn_base + turn_offset
    end

    def handicap?
      @handicap
    end

    ################################################################################ FIXME: これは使われてない？
    def order_info
      OrderInfo.fetch(order_key)
    end

    def order_key
      if display_turn.even?
        :sente
      else
        :gote
      end
    end
    ################################################################################

    def current_location(diff = 0)
      Location[current_location_index(diff)]
    end

    def location_call_name
      current_location.call_name(handicap?)
    end

    def inspect
      "#<#{turn_base}+#{turn_offset}:#{current_location.name}#{location_call_name}番>"
    end

    private

    def base_location
      if handicap?
        key = :white
      else
        key = :black
      end
      Location[key]
    end

    def current_location_index(diff)
      base_location.code + display_turn + diff
    end
  end
end
