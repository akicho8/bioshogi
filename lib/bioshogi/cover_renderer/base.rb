module Bioshogi
  class CoverRenderer
    concerning :Base do
      included do
        cattr_accessor :default_params do
          {
            :text         => nil,
            :width        => 1200,
            :height       => 630,
            :font_size    => 64,
            :bg_color     => "hsl(0,0%,15%)",
            :font_color   => "hsl(0,0%,100%)",
            :density      => "72x84", # xおよびy方向のテキスト密度。少し縦長にしておく。デフォルトは「72x72」
            :pull_to_top  => 0.02,    # 上にずらす割り合い。中央は下がって見えるため少し上に上げておく
            :image_format => "png",
            :font_regular => "#{__dir__}/../assets/fonts/RictyDiminished-Regular.ttf",  # 駒のフォント(普通)
            :font_bold    => "#{__dir__}/../assets/fonts/RictyDiminished-Bold.ttf",     # 駒のフォント(太字)
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
        gc = Magick::Draw.new
        gc.font      = params[:font_regular]
        gc.fill      = params[:font_color]
        gc.pointsize = params[:font_size]
        gc.density   = params[:density]
        gc.gravity   = Magick::CenterGravity
        gc.annotate(@canvas_layer, 0, 0, 0, @canvas_layer.rows * -1 * params[:pull_to_top], params[:text])
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
