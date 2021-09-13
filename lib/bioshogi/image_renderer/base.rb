module Bioshogi
  class ImageRenderer
    concerning :Base do
      included do
        cattr_accessor :default_params do
          {
            # required
            :width  => 1200, # 画像横幅
            :height => 630,  # 画像縦幅

            # 将棋盤の比率は先に 0.96 を適当に決めてそこから横幅の比率を出している
            # 0.95 * (33.3 / 36.4) = 0.8690934065934065
            :aspect_ratio_w => 0.8690934065934065, # 縦横幅の小さい方に対する盤の横幅の割合(横長の場合縦比率より小さめにする)
            :aspect_ratio_h => 0.95,               # 縦横幅の小さい方に対する盤の縦幅の割合(横長の場合1.0にすると縦の隙間がなくなる)

            # 文字の大きさの割合
            # ※割合はすべてセルの大きさを1.0とする
            :soldier_font_scale => 0.85, # 盤上駒
            :piece_scale_map => {},

            # 駒(文字)の位置調整
            :piece_char_adjust => {
              :black => [0.0425, 0.07],
              :white => [0.0,    0.01],
            },
            # 盤
            :canvas_bg_color          => "rgba(255,255,255,1.0)",     # 部屋の色(必須)
            :piece_font_color         => "rgba(0,0,0,0.8)",           # 駒の色(必須)
            :star_size                => 0.03,                        # 星のサイズ(割合)
            :lattice_stroke_width     => 1,                           # 格子の線の太さ
            :inner_frame_stroke_width => 2,                           # 枠の線お太さ(nil なら lattice_stroke_width を代用)
            :inner_frame_fill_color   => nil,                         # 基本透明とする(基本指定なしでよい)
            :dimension_w              => Dimension::Xplace.dimension, # 横のセル数
            :dimension_h              => Dimension::Yplace.dimension, # 縦のセル数
            :fg_file       => nil,                         # 盤テクスチャ

            # optional
            :last_soldier_font_color    => nil,                         # *最後に動いた駒の色。基本指定しない。(nilなら piece_font_color を代用)
            :stand_piece_color          => nil,                         # *持駒の色(nilなら piece_font_color を代用)
            :inner_frame_lattice_color  => "rgba(0,0,0,0.6)",           # *格子の色(nilなら piece_font_color を代用)
            :star_fill_color            => nil,                         # *星の色(nilなら inner_frame_lattice_color を代用)
            :inner_frame_stroke_color   => "rgba(0,0,0,0.6)",           # *格子の外枠色(nilなら piece_font_color を代用) これだけで全体イメージが変わる超重要色
            :promoted_font_color        => "rgba(255,0,0,0.8)",         # *成駒の色(nilなら piece_font_color を代用)

            :outer_frame_padding        => 0,                           # 盤の余白
            :outer_frame_radius         => 0.05,                        # 盤の角の丸め
            :outer_frame_fill_color     => "transparent",               # 盤の色
            :outer_frame_stroke_color   => "transparent",
            :outer_frame_stroke_width   => 0,

            :cell_colors                => nil,                         # セルの色 複数指定可
            :piece_move_cell_fill_color => "rgba(0,0,0,0.05)",          # 移動元と移動先のセルの背景色(nilなら描画しない)
            :normal_piece_color_map     => {},                          # 成ってない駒それぞれの色(nilなら piece_font_color を代用)

            # font
            :font_theme_key        => nil,                         # フォントの種類 noto_seif
            :font_regular          => "#{__dir__}/../assets/fonts/RictyDiminished-Regular.ttf", # 駒のフォント(普通)
            :font_bold             => "#{__dir__}/../assets/fonts/RictyDiminished-Bold.ttf",    # 駒のフォント(太字) (shogi-extendから直接参照しているためnilにしてはいけない)
            :soldier_font_bold => false,                       # 常に太字を使うか？

            # :font_regular           => "/Users/ikeda/Downloads/KsShogiPieces/KsShogiPieces.ttf", # 駒のフォント(普通)

            # other
            :viewpoint                => "black", # 視点
            :image_format             => "png",   # 出力する画像タイプ
            :negate                   => false,   # 反転
            :bg_file                  => nil,     # 背景ファイル
            :canvas_pattern_key       => nil,     # 背景パターン

            :color_theme_key          => "color_theme_is_paper_simple",
            :renderer_override_params          => {},

            # 連続で生成するか？
            # 昔はリサイズ後の背景をキャッシュしたりしていたが
            # レイヤー化してそもそも背景を破壊しないので必要になくなった
            :continuous_render         => false,
          }
        end

        cattr_accessor(:star_step) { 3 } # 星はnセルごとに書く
      end

      attr_accessor :mediator
      attr_accessor :params
      attr_accessor :hand_log

      delegate :logger, to: "Bioshogi"

      def initialize(mediator, params = {})
        # params.assert_valid_keys(default_params.keys)

        @mediator = mediator
        @params = default_params.merge(params)

        if v = @params[:color_theme_key]
          @params.update(ColorThemeInfo.fetch(v).to_params)
        end

        if v = @params[:font_theme_key]
          @params.update(FontThemeInfo.fetch(v).to_params)
        end

        if v = @params[:renderer_override_params]
          @params.update(v)
        end

        @build_counter = 0
      end

      def render
        logger.tagged(@build_counter) do
          require "rmagick"

          @hand_log = mediator.hand_logs.last

          # たまたまレイヤー単位でまとめられたけど本当はレイヤーを気にせずに「やりたいこと単位」でまとめるべき
          logger.info "static layer"
          @s_canvas_layer  ||= canvas_layer_create
          @s_board_layer   ||= board_layer_create
          @s_lattice_layer ||= lattice_layer_create
          @s_pattern_layer ||= pattern_layer_create

          # こちらの stand_draw を見ればレイヤー単位でまとめるのは難しいことがわかる
          logger.info "dynamic layer"
          dynamic_layer_setup
          soldier_move_cell_draw  # to d_move_layer
          soldier_draw_all        # to d_piece_layer
          stand_draw              # to d_piece_layer, d_piece_count_layer

          logger.info "composite process"
          current = @s_canvas_layer.composite(@s_board_layer,      0, 0, Magick::OverCompositeOp)                                                                        # 背景 + 物'
          current = current.composite(@d_move_layer,               0, 0, Magick::OverCompositeOp)                                                                        # 背景 + 物'
          current = current.composite(@s_lattice_layer,            0, 0, Magick::OverCompositeOp)                                                                        # 背景 + 物'
          current = current.composite(with_shadow(@d_piece_layer), 0, 0, Magick::OverCompositeOp)                                                                        # 背景 + 物'
          current = current.composite(@d_piece_count_layer,        0, 0, Magick::OverCompositeOp)                                                                        # 背景 + 物'

          current = condition_then_flip(current)
          current = condition_then_negate(current)

          @build_counter += 1
          current
        end
      end

      private

      def canvas_layer_create
        case
        when false
          # layer = Magick::Image.read("logo:").first
          layer = Magick::Image.read(Pathname("#{__dir__}/../assets/images/matrix_1024x768.png")).first
          layer = Magick::Image.read(Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path).first
          layer = CanvasPattern.fetch(:pattern_checker_dark).func(self).copy
          layer.resize!(*image_rect) # 200 ms
          # layer.blur_image(20.0, 10.0)
          # layer = layer.emboss
          # layer = Magick::Image.read("netscape:").first.resize(*image_rect)
          layer = condition_then_flip(layer) # 全体を反転するので背景だけ反転しておくことで元に戻る
        when v = params[:canvas_pattern_key]
          layer = CanvasPatternInfo.fetch(v).execute(rect: image_rect)
        when v = params[:bg_file]
          layer = Magick::Image.read(v).first
          # layer.resize_to_fit!(*image_rect)  # 指定したサイズより(画像が小さいと)画像のサイズになる
          layer.resize_to_fill!(*image_rect) # アス比を維持して中央を切り取る
          # layer.resize!(*image_rect) # 200 ms
          layer = condition_then_flip(layer) # 全体を反転するので背景だけ反転しておくことで元に戻る
        else
          layer = Magick::Image.new(*image_rect) do |e|
            e.background_color = params[:canvas_bg_color]
          end
        end

        # 白黒の場合 GRAYColorspace になっていてこれに盤を重ねると白黒になってしまう、のを防ぐ
        layer.colorspace = Magick::SRGBColorspace

        # if params[:continuous_render]
        #   @continuous_render = layer.copy
        # end

        logger.info { "canvas_layer_create for s_canvas_layer" }

        layer
      end

      def condition_then_flip(layer)
        if params[:viewpoint].to_s == "white"
          layer.rotate(180) # 5 ms
        else
          layer
        end
      end

      def condition_then_negate(layer)
        if params[:negate]
          layer.negate
        else
          layer
        end
      end

      # draw の時点で最後に指定した fill が使われる
      def draw_context(layer)
        g = Magick::Draw.new
        yield g
        g.draw(layer)
      end

      def cell_walker
        lattice.h.times do |y|
          lattice.w.times do |x|
            yield V[x, y]
          end
        end
      end

      def px(v)
        # もともとセルは正方形だった
        # だから「top_left + v * cell_w」でよかった
        # これは w, h を同じ値で乗算する
        # するとセルが正方形になる
        # しかし実際の将棋盤は縦長なので正方形にすると心理的に押し潰された印象になってしまう
        # なので w * 90, h * 100 のような感じにしないといけない
        # [90, 100] みたいなのは cell_rect に入っている
        # ベクトルのそれぞれの位置を掛け算するには map2 を使う
        # https://docs.ruby-lang.org/ja/latest/class/Vector.html
        # collect2 だと Array になってしまうので注意
        # map2 を使わないのなら top_left + V[v.x * cell_w, v.y * cell_h] で良い
        # ベタな書き方をしてみたけど速度に影響なし
        # また v でメモ化してみたけどこれも影響なし
        top_left + ps(v)
      end

      # pixel size
      def ps(v)
        v.map2(cell_rect) { |a, b| a * b }
      end

      def minus_one(x, y)
        [x - 1, y - 1]
      end

      def line_draw(g, v1, v2)
        g.line(*px(v1), *px(v2))
      end

      def cell_draw(g, v)
        if v
          g.rectangle(*px(v), *px(v + V.one))
        end
      end

      def image_rect
        @image_rect ||= Rect[params[:width], params[:height]]
      end

      def lattice
        @lattice ||= Rect[params[:dimension_w], params[:dimension_h]]
      end

      def cell_w
        @cell_w ||= (vmin * params[:aspect_ratio_w]) / lattice.w
      end

      def cell_h
        @cell_h ||= (vmin * params[:aspect_ratio_h]) / lattice.h
      end

      def vmin
        @vmin ||= image_rect.to_a.min
      end

      def cell_rect
        @cell_rect ||= Rect[cell_w, cell_h]
      end

      def center
        @center ||= V[@s_canvas_layer.columns / 2, @s_canvas_layer.rows / 2]
      end

      def top_left
        @top_left ||= center - cell_rect.map2(lattice) { |a, b| a * b } / 2
      end

      def v_bottom_right_outer
        @v_bottom_right_outer ||= V[lattice.w, lattice.h - 1]
      end

      def v_top_left_outer
        @v_top_left_outer ||= V[-1, 0]
      end

      def lattice_stroke_width
        params[:lattice_stroke_width]
      end

      def inner_frame_stroke_width
        params[:inner_frame_stroke_width] || lattice_stroke_width || 0
      end

      def image_format
        params[:image_format].presence or raise ArgumentError, "params[:image_format] is blank"
      end

      def ext_name
        image_format
      end

      def outer_frame_radius
        if params[:outer_frame_padding].zero?
          0 # 隙間が無い場合は線だけの角なので丸めるとセルが削れる。なので強制的に0
        else
          params[:outer_frame_radius]
        end
      end

      # 盤の外側とセルの隙間
      def outer_frame_padding
        V.one * params[:outer_frame_padding]
      end

      # 角の丸め度合い
      def round_radious
        cell_rect * outer_frame_radius
      end

      # 外側の左上
      def outer_top_left
        V[0, 0] - outer_frame_padding
      end

      # 外側の左下
      def outer_bottom_right
        V[lattice.w, lattice.h] + outer_frame_padding
      end

      # 外側の領域
      def outer_rect
        outer_bottom_right - outer_top_left
      end
    end
  end
end
