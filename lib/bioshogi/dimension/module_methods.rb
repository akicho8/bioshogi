# frozen-string-literal: true

module Bioshogi
  module Dimension
    module ModuleMethods
      # 一時的に盤面のサイズを変更する(テスト用)
      #
      #   before do
      #     @size_save = Dimension.wh_change([3, 5])
      #   end
      #   after do
      #     Dimension.wh_change(@size_save)
      #   end
      #
      def wh_change(wsize, &block)
        save_value = dimension_wh
        h, v = wsize
        PlaceX.dimension_set(h)
        PlaceY.dimension_set(v)
        if block_given?
          begin
            yield
          ensure
            h, v = save_value
            PlaceX.dimension_set(h)
            PlaceY.dimension_set(v)
          end
        else
          save_value
        end
      end

      def dimension_info
        DimensionInfo.fetch(dimension_wh)
      end

      def dimension_wh
        [PlaceX.dimension, PlaceY.dimension]
      end
    end
  end
end
