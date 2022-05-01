# frozen-string-literal: true

module Bioshogi
  class ChessClock
    def initialize
      @mini_clocks = LocationInfo.inject({}) {|a, e| a.merge(e => PersonalClock.new) }
      @counter = 0
    end

    def add(v)
      @mini_clocks[LocationInfo[@counter]].add(v)
      @counter += 1
    end

    def last_clock
      @mini_clocks[LocationInfo[@counter.pred]]
    end

    def to_s
      last_clock.to_s
    end

    class PersonalClock
      attr_reader :total_seconds
      attr_reader :used_seconds

      def initialize
        @total_seconds = 0
        @used_seconds = 0
      end

      def add(v)
        v = v.to_i
        if v.negative?
          raise TimeMinusError, "消費時間がマイナスになっています : #{v}"
        end
        @total_seconds += v
        @used_seconds = v
      end

      def to_s
        h, r = @total_seconds.divmod(1.hour)
        m, s = r.divmod(1.minute)
        "(%02d:%02d/%02d:%02d:%02d)" % [*@used_seconds.divmod(1.minute), h, m, s]
      end

      def to_h
        {
          :total_seconds => total_seconds,
          :used_seconds => used_seconds,
        }
      end
    end
  end
end
