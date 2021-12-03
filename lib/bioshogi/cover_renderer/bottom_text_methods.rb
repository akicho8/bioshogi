module Bioshogi
  class CoverRenderer
    concerning :BottomTextMethods do
      class_methods do
        def default_params
          super.merge({
              :bottom_text           => nil,
              :bottom_text_pointsize => 32,
              :bottom_text_margin    => 8,
            })
        end
      end

      private

      def bottom_text_render
        if bottom_text
          gc = Magick::Draw.new
          gc.font      = params[:font_regular]
          gc.fill      = params[:font_color]
          gc.pointsize = params[:bottom_text_pointsize]
          gc.gravity   = Magick::SouthEastGravity # 右下
          margin = params[:bottom_text_margin]
          gc.annotate(@canvas_layer, 0, 0, margin, margin, bottom_text)
        end
      end

      def bottom_text
        @bottom_text ||= text_normalize(params[:bottom_text])
      end
    end
  end
end
