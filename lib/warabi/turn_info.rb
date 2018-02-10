# frozen-string-literal: true

module Warabi
  class TurnInfo
    attr_accessor :counter
    attr_accessor :handicap

    def initialize(handicap: false, counter: 0)
      @handicap = handicap
      @counter = counter || 0
    end

    def handicap?
      @handicap
    end

    def base_location
      if @handicap
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
      if counter.even?
        :sente
      else
        :gote
      end
    end

    def current_location(diff = 0)
      Location[current_location_index(diff)]
    end

    def current_location_vname
      current_location.call_name(handicap?)
    end

    def inspect
      "<#{self.class.name}:#{object_id} 手数:#{counter} 駒落ち:#{handicap?} 次の手番:#{current_location.name}>"
    end

    private

    def current_location_index(diff)
      base_location.code + @counter + diff
    end
  end
end
