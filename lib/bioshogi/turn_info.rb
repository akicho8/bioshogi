# frozen-string-literal: true

module Bioshogi
  class TurnInfo
    attr_accessor :base_counter
    attr_accessor :counter
    attr_writer :handicap

    def initialize(handicap: false, counter: nil, base_counter: nil)
      @handicap = handicap
      @counter = counter || 0
      @base_counter = base_counter || 0
    end

    def display_turn
      base_counter + counter
    end

    def turn_offset
      counter
    end

    def handicap?
      @handicap
    end

    def base_location
      if handicap?
        key = :white
      else
        key = :black
      end
      Location[key]
    end

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

    def current_location(diff = 0)
      Location[current_location_index(diff)]
    end

    def location_call_name
      current_location.call_name(handicap?)
    end

    def inspect
      "#<#{base_counter}+#{counter}:#{current_location.name}#{location_call_name}番>"
    end

    private

    def current_location_index(diff)
      base_location.code + display_turn + diff
    end
  end
end
