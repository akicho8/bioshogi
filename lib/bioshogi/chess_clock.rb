module Bioshogi
  class ChessClock
    def initialize
      @mini_clocks = Location.inject({}) {|a, e| a.merge(e => PersonalClock.new) }
      @counter = 0
    end

    def add(v)
      @mini_clocks[Location[@counter]].add(v)
      @counter += 1
    end

    def last_clock
      @mini_clocks[Location[@counter.pred]]
    end

    def to_s
      last_clock.to_s
    end
  end
end
