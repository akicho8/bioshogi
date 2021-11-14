module Bioshogi
  class ImageRenderer
    concerning :TurnMethods do
      class_methods do
        def default_params
          super.merge({
              :turn_embed_key => "is_turn_embed_off",  # 現在の手数を埋めるか？
            })
        end
      end

      def turn_draw(layer)
        if params[:turn_embed_key] == "is_turn_embed_on"
          logger.info "turn_draw"

          pointsize = cell_w * 0.75
          w = pointsize * 4
          h = pointsize
          x = pointsize * 0.3
          y = pointsize * 0.1

          # r = cell_w * 0.5
          # @d_turn_layer = Magick::Image.new(w, h) { |e| e.background_color = "transparent" }

          # gc = Magick::Draw.new
          # gc.fill(params[:piece_count_bg_color])
          # from = [x + w/2, y + h/2]
          # to   = [x + w/2 + r, y + h/2]
          # gc.circle(*from, *to)
          # gc.draw(@d_turn_layer)

          gc = Magick::Draw.new
          gc.annotate(layer, w, h, x, y, "#{@build_counter}") do |e|
            e.font         = params[:font_bold]
            e.fill         = "hsla(0,0%,100%,1.0)"
            e.pointsize    = pointsize
            e.stroke_width = 2
            e.stroke       = "hsla(0,0%,0%,0.75)"
            e.gravity      = Magick::NorthWestGravity
          end
        end
      end
    end
  end
end
