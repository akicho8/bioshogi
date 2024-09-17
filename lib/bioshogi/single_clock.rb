# frozen-string-literal: true

module Bioshogi
  class SingleClock
    attr_reader :total_seconds
    attr_reader :used_seconds

    def initialize
      @total_seconds = 0
      @used_seconds = 0
    end

    def add(second)
      second = second.to_i
      if second.negative?
        # 将棋ウォーズの棋譜はまれにマイナスの消費時間が存在してこれになる
        raise ConsumedTimeMinusError, "消費時間がマイナスになっています : #{second}"
      end
      @total_seconds += second
      @used_seconds = second
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
