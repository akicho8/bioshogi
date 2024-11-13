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
        Column.default_size? && Row.default_size?
      end

      def dimension_info
        DimensionInfo.fetch(current_size)
      end

      def current_size
        [Column.dimension_size, Row.dimension_size]
      end

      private

      def set_wh(w, h)
        Column.size_reset(w)
        Row.size_reset(h)
        Place.cache_clear       # 超重要
      end
    end
  end
end
