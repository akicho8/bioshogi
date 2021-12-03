module Bioshogi
  class CoverRenderer
    concerning :Base do
      class_methods do
        def default_params
          {
            :text         => nil,
            :width        => 1200,
            :height       => 630,
            :image_format => "png",
            :font_regular => "#{__dir__}/../assets/fonts/RictyDiminished-Regular.ttf",  # 駒のフォント(普通)
            :font_bold    => "#{__dir__}/../assets/fonts/RictyDiminished-Bold.ttf",     # 駒のフォント(太字)
            :bg_color     => "hsl(0,0%,15%)",
            :font_color   => "hsl(0,0%,100%)",
          }
        end
      end

      attr_accessor :params

      def initialize(params = {})
        require "rmagick"
        @params = self.class.default_params.merge(params)
      end

      def render
        @canvas_layer = canvas_layer_create
        main_text_render
        bottom_text_render
        @canvas_layer
      end

      private

      # Ricty フォントでは全角が "「」" になってしまうため透明にする
      def text_normalize(str)
        str.to_s.gsub(/\u3000/, "  ")
      end

      def canvas_layer_create
        Magick::Image.new(*image_rect) do |e|
          e.background_color = params[:bg_color]
          if false
            # 予想に反してこれを指定しても RGB で保存されない
            # たまたま白黒だった画像をRGBで保存するには PNG24: としないといけない
            e.colorspace = Magick::SRGBColorspace
          end
        end
      end

      def image_rect
        Rect[params[:width], params[:height]]
      end

      def ext_name
        params[:image_format]
      end
    end
  end
end
