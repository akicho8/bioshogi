# frozen-string-literal: true

module Bioshogi
  module Dimension
    module ModuleMethods
      def wh_change(wsize, &block)
        save_value = dimension_wh
        set_wh(*wsize)
        if block_given?
          begin
            yield
          ensure
            set_wh(*save_value)
          end
        else
          save_value
        end
      end

      def dimension_info
        DimensionInfo.fetch(dimension_wh)
      end

      def dimension_wh
        [DimensionColumn.dimension_size, DimensionRow.dimension_size]
      end

      def default_size?
        DimensionColumn.default_size? && DimensionRow.default_size?
      end

      def set_wh(w, h)
        DimensionColumn.size_reset(w)
        DimensionRow.size_reset(h)
        Place.cache_clear       # 超重要
      end
    end
  end
end
