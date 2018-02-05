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

    # def next!
    #   @counter += 1
    # end

    def current_location(diff = 0)
      Location[current_location_index(diff)]
    end

    # def next_location
    #   current_location(1)
    # end
    #
    # def previous_location
    #   current_location(-1)
    # end

    def current_location_vname
      current_location.call_name(handicap?)
    end

    # def name1
    #   "#{@counter}手目"
    # end
    #
    # def name2
    #   current_location.public_send(call_name_key)
    # end
    #
    # def name3
    #   "#{name1} #{name2}"
    # end
    #
    # def inspect
    #   name3
    # end

    # def call_name_key
    #   if handicap?
    #     :handicap_name
    #   else
    #     :equality_name
    #   end
    # end

    # # "2手目" など
    # def location_fetch(value)
    #   case
    #   when value.kind_of?(String) && md = value.match(/(?<turn_number>\d+)/)
    #     index = md[:turn_number].to_i.pred
    #     current_location(index)
    #   when values.kind_of?(Integer)
    #     current_location(index)
    #   else
    #     raies MustNotHappen
    #   end
    # end

    private

    # def sente?
    #   counter.even?
    # end
    #
    # def gote?
    #   counter.odd?
    # end

    def current_location_index(diff)
      base_location.code + @counter + diff
    end
  end
end
