# frozen-string-literal: true

module Bioshogi
  module Dimension
    module ModuleMethods
      def change(wh, &block)
        save_value = current_size
        set_wh(*wh)
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

      def default_size?
        DimensionColumn.default_size? && DimensionRow.default_size?
      end

      def dimension_info
        DimensionInfo.fetch(current_size)
      end

      def current_size
        [DimensionColumn.dimension_size, DimensionRow.dimension_size]
      end

      private

      def set_wh(w, h)
        DimensionColumn.size_reset(w)
        DimensionRow.size_reset(h)
        Place.cache_clear       # 超重要
      end
    end
  end
end
