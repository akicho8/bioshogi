module Bioshogi
  class CoverRenderer
    concerning :Base do
      class_methods do
        def default_params
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
            :bottom_text           => nil,
            :bottom_text_pointsize => 32,
            :bottom_text_margin    => 8,
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
        gc = Magick::Draw.new
        gc.font      = params[:font_regular]
        gc.fill      = params[:font_color]
        gc.pointsize = params[:font_size]
        gc.density   = params[:density]
        gc.gravity   = Magick::CenterGravity # 中央
        x = 0
        y = @canvas_layer.rows * -1 * params[:pull_to_top] # 高さ x pull_to_top のぶんだけ持ち上げる
        gc.annotate(@canvas_layer, 0, 0, x, y, text)

        if str = bottom_text
          gc = Magick::Draw.new
          gc.font      = params[:font_regular]
          gc.fill      = params[:font_color]
          gc.pointsize = params[:bottom_text_pointsize]
          gc.gravity   = Magick::SouthEastGravity # 右下
          margin = params[:bottom_text_margin]
          gc.annotate(@canvas_layer, 0, 0, margin, margin, str)
        end

        @canvas_layer
      end

      private

      def text
        @text ||= params[:text].to_s.gsub(/\u3000/, "  ") # Ricty フォントでは全角が "「」" になってしまうため透明にする
      end

      def bottom_text
        params[:bottom_text].presence
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
