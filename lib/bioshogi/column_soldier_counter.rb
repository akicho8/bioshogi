# frozen-string-literal: true

#
# 列の駒数をなるべく高速に判定する
#
module Bioshogi
  class ColumnSoldierCounter
    attr_reader :counts

    def initialize
      reset
    end

    def reset
      @counts = Array.new(Dimension::Column.dimension_size, 0)
    end

    def set(place)
      update(place, 1)
    end

    def remove(place)
      update(place, -1)
    end

    def filled?(column)
      @counts[column.value] >= Dimension::Row.dimension_size
    end

    private

    def update(place, sign)
      key = place.column.value
      count = @counts[key] + sign
      validate!(place, count)
      @counts[key] = count
    end

    def validate!(place, count)
      if count > Dimension::Row.dimension_size
        raise MustNotHappen, "#{place.column.hankaku_number}の列に#{count}個目の駒を配置しようとしています。棋譜を二重に読ませようとしていませんか？"
      elsif count.negative?
        raise MustNotHappen, "#{place.column.hankaku_number}の列の駒の数がマイナスになろうとしている"
      end
    end
  end
end
