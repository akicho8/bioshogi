module Bioshogi
  class ImageFormatter
    concerning :LayerMethods do
      included do
        default_params.update({
          })
      end

      def layer_setup
        @board_layer       = transparent_layer
        @move_layer        = transparent_layer
        @piece_layer       = transparent_layer
        @lattice_layer     = transparent_layer
        @piece_count_layer = transparent_layer
      end

      def transparent_layer
        Magick::Image.new(*image_rect) { |e| e.background_color = "transparent" }
      end

      # 指定のレイヤーに影をつける
      def with_shadow(layer)
        s = layer.shadow( # https://rmagick.github.io/image3.html#shadow
          params[:shadow2_offset],
          params[:shadow2_offset],
          params[:shadow2_sigma],
          params[:shadow2_opacity])
        s.composite(layer, 0, 0, Magick::OverCompositeOp) # 影の上に乗せる
      ensure
        s.destroy!
      end
      
      
    end
  end
end
