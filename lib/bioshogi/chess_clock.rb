# frozen-string-literal: true

module Bioshogi
  class ChessClock
    def initialize
      @single_clocks = Location.inject({}) {|a, e| a.merge(e => SingleClock.new) }
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

    class SingleClock
      attr_reader :total
      attr_reader :used

      def initialize
        @total = 0
        @used = 0
      end

      def add(v)
        v = v.to_i
        @total += v
        @used = v
      end

      def to_s
        h, r = @total.divmod(1.hour)
        m, s = r.divmod(1.minute)
        "(%02d:%02d/%02d:%02d:%02d)" % [*@used.divmod(1.minute), h, m, s]
      end
    end
  end
end
