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
      freeze
    end

    def next
      self.class.new(handicap: handicap, turn_base: nil, turn_offset: turn_offset.next)
    end

    def inspect
      "#<#{handicap? ? '駒落ち' : '平手'}:#{turn_base}+#{turn_offset}:#{current_location.name}#{location_call_name}番>"
    end

    # 戦法判定や表示するときに用いる手数
    def display_turn
      turn_base + turn_offset
    end

    # turn_offset が 0 と仮定したときの手番
    def turn_offset_zero_location
      Location[location_consider_handicap.code + turn_base]
    end

    # 現在の手番
    def current_location(diff = 0)
      Location[location_consider_handicap.code + turn_base + turn_offset + diff]
    end

    def location_call_name
      current_location.call_name(handicap?)
    end

    def handicap?
      @handicap
    end

    def order_info
      OrderInfo.fetch(order_key)
    end

    # for SkillMonitor
    def order_key
      if display_turn.even?
        :sente
      else
        :gote
      end
    end

    private

    # 駒落ちを考慮した最初の location
    def location_consider_handicap
      if handicap?
        key = :white
      else
        key = :black
      end
      Location[key]
    end
  end
end
