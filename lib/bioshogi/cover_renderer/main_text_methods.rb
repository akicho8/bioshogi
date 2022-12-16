module Bioshogi
  module CoverRenderer
    concern :MainTextMethods do
      class_methods do
        def default_params
          super.merge({
              :font_size    => 80,
              :density      => "72x84", # xおよびy方向のテキスト密度。少し縦長にしておく。デフォルトは「72x72」
              :pull_to_top  => 0.02,    # 上にずらす割り合い。中央は下がって見えるため少し上に上げておく
            })
        end
      end

      private

      def main_text_render
        gc = Magick::Draw.new
        gc.font      = params[:font_regular].to_s
        gc.fill      = params[:font_color]
        gc.pointsize = params[:font_size]
        gc.density   = params[:density]
        gc.gravity   = Magick::CenterGravity # 中央
        # gc.interword_spacing = 0 # 半角スペースをさらに広げる場合に指定
        # gc.kerning = 0           # 文字間隔
        # gc.decorate = Magick::OverlineDecoration
        x = 0
        y = @canvas_layer.rows * -1 * params[:pull_to_top] # 高さ x pull_to_top のぶんだけ持ち上げる
        gc.annotate(@canvas_layer, 0, 0, x, y, text)
      end

      def text
        @text ||= text_normalize(params[:text])
      end
    end
  end
end
