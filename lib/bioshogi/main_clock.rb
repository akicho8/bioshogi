module Bioshogi
  class MainClock
    def initialize
      @single_clocks = Location.inject({}) { |a, e| a.merge(e => SingleClock.new) }
      @counter = 0
    end

    def add(v)
      @single_clocks[Location[@counter]].add(v)
      @counter += 1
    end

    def last_clock
      @single_clocks[Location[@counter.pred]]
    end

    def to_s
      last_clock.to_s
    end
  end
end
