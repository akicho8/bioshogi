module Bioshogi
  class ImageFormatter
    concerning :LayerMethods do
      included do
        default_params.update({
            # 共通の影
            :real_shadow_offset  => -4,  # 影の長さ 効いてない
            :real_shadow_sigma   => 1.5, # 影の強さ (0:影なし)
            :real_shadow_opacity => 0.4, # 不透明度
          })
      end

      def layer_destroy_all
        logger.tagged(:layer_destroy_all) do
          [
            :s_canvas_layer,
            :s_board_layer,
            :s_lattice_layer,

            :d_move_layer,
            :d_piece_layer,
            :d_piece_count_layer,

            :rendered_image,
          ].each do |e|
            if v = instance_variable_get("@#{e}")
              v.destroy!
              instance_variable_set("@#{e}", nil)
              logger.info { "@#{e}.destroy!" }
            end
          end
        end
      end

      def dynamic_layer_setup
        @d_move_layer        = transparent_layer(:d_move_layer)
        @d_piece_layer       = transparent_layer(:d_piece_layer)
        @d_piece_count_layer = transparent_layer(:d_piece_count_layer)
      end

      def transparent_layer(key)
        logger.info { "transparent_layer create for #{key}" }
        Magick::Image.new(*image_rect) { |e| e.background_color = "transparent" }
      end

      # 指定のレイヤーに影をつける
      def with_shadow(layer)
        if params[:real_shadow_sigma].nonzero?
          s = layer.shadow( # https://rmagick.github.io/image3.html#shadow
            params[:real_shadow_offset],
            params[:real_shadow_offset],
            params[:real_shadow_sigma],
            params[:real_shadow_opacity])
          layer = s.composite(layer, 0, 0, Magick::OverCompositeOp) # 影の上に乗せる
          s.destroy!
        end
        layer
      end
    end
  end
end
