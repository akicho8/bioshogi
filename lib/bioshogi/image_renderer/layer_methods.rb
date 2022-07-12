module Bioshogi
  class ImageRenderer
    concerning :LayerMethods do
      class_methods do
        def default_params
          super.update({
              # 共通の影
              :real_shadow_offset  => 3,    # 影のズレ
              :real_shadow_sigma   => 1.5,  # 影の広がり (0:影なし)
              :real_shadow_opacity => 0.4,  # 不透明度
            })
        end
      end

      # いらない？
      def clear_all
        logger.tagged(:clear_all) do
          [
            :s_canvas_layer,
            :s_board_layer,
            :s_lattice_layer,

            :d_move_layer,
            :d_piece_layer,
            :d_piece_count_layer,
            :d_turn_layer,

            :last_rendered_image,
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
        logger.info { "transparent_layer create for #{key} BEGIN" }
        Magick::Image.new(*image_rect) { |e| e.background_color = "transparent" }.tap do
          logger.info { "transparent_layer create for #{key} END" }
        end
      end

      # フォントでの駒のときだけ駒レイヤーに影をつける
      def with_shadow_only_font_pice(layer)
        if params[:piece_image_key]
          layer
        else
          with_shadow(layer)
        end
      end

      # 指定のレイヤーに影をつける
      def with_shadow(layer)
        if params[:real_shadow_sigma].nonzero?
          s = layer.shadow( # https://rmagick.github.io/image3.html#shadow
            params[:real_shadow_offset],
            params[:real_shadow_offset],
            params[:real_shadow_sigma],
            params[:real_shadow_opacity])
          if false
            # 間違った方法
            # 影のレイヤーは内部のオフセットがずれているだけなのでこの方法ではオフセットが効いてないように見える
            layer = s.composite(layer, 0, 0, Magick::OverCompositeOp) # 影の上に乗せる
          else
            # 意図した通りに重ねる
            list = Magick::ImageList.new
            list.new_image(layer.columns, layer.rows, Magick::SolidFill.new("transparent"))
            list << s
            list << layer
            layer = list.flatten_images
          end
          s.destroy!
        end
        layer
      end
    end
  end
end
