require "kconv"

module Bioshogi
  class CardGenerator
    concerning :Base do
      included do
        cattr_accessor :default_params do
          {
            :text             => nil,
            :width            => 1200,
            :height           => 630,
            :font_size        => 64,
            :bg_color         => "hsl(0,0,15%)",
            :font_color       => "hsl(0,0,100%)",
            :density          => "72x84", # xおよびy方向のテキスト密度。デフォルトは「72x72」
            # static
            :image_format     => "png",
            :font_regular     => "#{__dir__}/../assets/fonts/RictyDiminished-Regular.ttf", # 駒のフォント(普通)
            :font_bold        => "#{__dir__}/../assets/fonts/RictyDiminished-Bold.ttf",    # 駒のフォント(太字)
          }
        end
      end

      attr_accessor :params

      def initialize(params = {})
        require "rmagick"
        @params = default_params.merge(params)
      end

      def render
        @canvas_layer = canvas_layer_create
        draw = Magick::Draw.new
        draw.font           = params[:font_regular]
        draw.fill           = params[:font_color]
        draw.pointsize      = params[:font_size]
        draw.gravity        = Magick::CenterGravity
        draw.density        = params[:density]
        draw.annotate(@canvas_layer, 0, 0, 0, 0, params[:text])
        @canvas_layer
      end

      private

      def canvas_layer_create
        Magick::Image.new(*image_rect) do |e|
          e.background_color = params[:bg_color]
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
