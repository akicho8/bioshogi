# frozen-string-literal: true

#
# 駒柱をなるべく高速に判定する
#
module Bioshogi
  class PillerCop
    attr_reader :counts
    attr_accessor :active

    def initialize
      reset
    end

    def active?
      @active
    end

    def reset
      @counts = Array.new(Dimension::Column.dimension_size, 0)
      @active = false
    end

    def set(place)
      index = place.column.value
      count = @counts[index] + 1
      if count > Dimension::Row.dimension_size
        raise MustNotHappen, "#{place.column.hankaku_number}の列に#{count}個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？"
      end
      @counts[index] = count
      if count == Dimension::Row.dimension_size
        @active = true
      end
    end

    def remove(place)
      index = place.column.value
      count = @counts[index] - 1
      if count.negative?
        raise MustNotHappen, "#{place.column.hankaku_number}の列の駒の数がマイナスになろうとしていています"
      end
      @counts[index] = count
      if count == Dimension::Row.dimension_size - 1
        @active = false
      end
    end
  end
end
