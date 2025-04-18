module Bioshogi
  module ScreenImage
    concern :CoreMethods do
      class_methods do
        def default_params
          super.merge({
              # 必須
              :width  => 1200, # 画像横幅
              :height => 630,  # 画像縦幅

              # 将棋盤の比率
              # 実際の比率は 横:33.3 縦:36.4
              # 高さ最大を1.0として隙間を考慮して 0.95 と仮に決めると
              # 0.95 * (33.3 / 36.4) で横幅は 0.8690934065934065 になる
              :aspect_ratio_w => 0.8690934065934065, # 縦横幅の小さい方に対する盤の横幅の割合(横長の場合縦比率より小さめにする)
              :aspect_ratio_h => 0.95,               # 縦横幅の小さい方に対する盤の縦幅の割合(横長の場合1.0にすると縦の隙間がなくなる)

              # 文字の大きさの割合
              # ※割合はすべてセルの大きさを1.0とする
              :soldier_font_scale => 0.85, # PieceScale に掛ける共通倍率。かなり印象が変わる。1.00 だと暑苦しい。
              :piece_scale_map    => {},

              # 駒(文字)の位置調整
              :piece_char_adjust => {
                :black => [0.0425, 0.07],
                :white => [0.0,    0.01],
              },

              # 盤
              :canvas_bg_color          => "hsla(0,0%,100%,1.0)",            # 部屋の色(必須)
              :piece_font_color         => "hsla(0,0%,0%,0.8)",              # 駒の色(必須)
              :lattice_stroke_width     => 1,                                # 格子の線の太さ
              :inner_frame_stroke_width => 2,                                # 枠の線お太さ(nil なら lattice_stroke_width を代用)
              :inner_frame_fill_color   => nil,                              # 基本透明とする(基本指定なしでよい)
              :dimension_w              => Dimension::Column.dimension_size, # 横のセル数
              :dimension_h              => Dimension::Row.dimension_size,    # 縦のセル数
              :fg_file                  => nil,                              # 盤テクスチャ

              # optional
              :last_soldier_font_color    => nil,                     # *最後に動いた駒の色。基本指定しない。(nilなら piece_font_color を代用)
              :stand_piece_color          => nil,                     # *持駒の色(nilなら piece_font_color を代用)
              :inner_frame_lattice_color  => "hsla(0,0%,0%,0.6)",     # *格子の色(nilなら piece_font_color を代用)
              :inner_frame_stroke_color   => "hsla(0,0%,0%,0.6)",     # *格子の外枠色(nilなら piece_font_color を代用) これだけで全体イメージが変わる超重要色
              :promoted_font_color        => "hsla(0,100%, 50%,0.8)", # *成駒の色(nilなら piece_font_color を代用)

              :outer_frame_padding        => 0,                           # 盤の余白
              :outer_frame_radius         => 0.05,                        # 盤の角の丸め
              :outer_frame_fill_color     => "transparent",               # 盤の色
              :outer_frame_stroke_color   => "transparent",               # 外枠の縁取り色(鬼滅盤用)
              :outer_frame_stroke_width   => 0,                           # 外枠の縁取り幅(鬼滅盤用)

              :cell_colors                => nil,                         # セルの色 複数指定可
              :piece_move_cell_fill_color => "hsla(0,0%,0%,0.05)",        # 移動元と移動先のセルの背景色(nilなら描画しない)
              :normal_piece_color_map     => {},                          # 成ってない駒それぞれの色(nilなら piece_font_color を代用)

              # フォント駒
              :font_theme_key        => nil,                                                  # フォントの種類 noto_seif
              :font_regular          => ASSETS_DIR.join("fonts/RictyDiminished-Regular.ttf"), # 駒のフォント(普通)
              :font_bold             => ASSETS_DIR.join("fonts/RictyDiminished-Bold.ttf"),    # 駒のフォント(太字) (shogi-extendから直接参照しているためnilにしてはいけない)
              :soldier_font_bold     => false,                                                # 太字を使うか？
              :piece_font_weight_key => :is_piece_font_weight_auto,                           # 太字はおまかせ (つまり何もしない。nil でもよい)

              # 画像駒
              :piece_image_key   => nil, # どの画像駒を使うか？ (nil なら使わない)
              :piece_image_scale => nil, # 画像駒の大きさ (nil なら PieceImageInfo の default_scale を使う)

              # other
              :viewpoint    => "black", # 視点
              :image_format => "png",   # 出力する画像タイプ
              :negate       => false,   # 反転
              :bg_file      => nil,     # 背景ファイル

              # star
              :star_size       => 0.03, # 星のサイズ(割合)
              :star_fill_color => nil,  # *星の色(nilなら inner_frame_lattice_color を代用)
              :star_step       => 3,    # 星はnセルごとに書く

              :color_theme_key          => "is_color_theme_modern", # 色テーマ
              :renderer_override_params => {},                      # 色テーマを上書きするパラメータ
            })
        end
      end

      attr_accessor :container
      attr_accessor :params
      attr_accessor :hand_log

      delegate :logger, to: "Bioshogi"

      def initialize(container, params = {})
        # params.assert_valid_keys(default_params.keys)

        @container = container
        @params = self.class.default_params.merge(params)

        # 一つ一つのパラメータを設定するのは大変である
        # そこで以下を設定するとまとまったパラメータを一気に設定する
        # - color_theme_key
        # - font_theme_key
        # - piece_font_weight_key

        if e = ColorThemeInfo.lookup(@params[:color_theme_key])
          @params.update(e.to_params)
        end

        if e = FontThemeInfo.lookup(@params[:font_theme_key])
          @params.update(e.to_params)
        end

        if e = PieceFontWeightInfo.lookup(@params[:piece_font_weight_key])
          @params.update(e.to_params)
        end

        # 最終的に調整したいときは renderer_override_params に指定するとすべてを上書きできる
        if v = @params[:renderer_override_params]
          @params.update(v)
        end

        @build_counter = 0
      end

      def render
        logger.tagged(@build_counter) do
          require "rmagick"

          @hand_log = container.hand_logs.last

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

          # メモリが足りないとこのどこかで落ちる
          logger.info "composite"
          current = @s_canvas_layer.composite(@s_board_layer,      0, 0, Magick::OverCompositeOp) # 背景 + 物'
          current = current.composite(@d_move_layer,               0, 0, Magick::OverCompositeOp) # 背景 + 物'
          current = current.composite(@s_lattice_layer,            0, 0, Magick::OverCompositeOp) # 背景 + 物'
          current = current.composite(with_shadow_only_font_pice(@d_piece_layer), 0, 0, Magick::OverCompositeOp) # 背景 + 物'
          current = current.composite(@d_piece_count_layer,        0, 0, Magick::OverCompositeOp) # 背景 + 物'

          logger.info "condition_then_flip"
          current = condition_then_flip(current)

          turn_draw(current)    # レイヤーを作らず直接書き込み

          current = condition_then_color_negate(current) # 色反転

          @build_counter += 1
          current
        end
      end

      private

      def canvas_layer_create
        case
        when false
          # layer = Magick::Image.read("logo:").first
          layer = Magick::Image.read(ASSETS_DIR.join("images/matrix_1024x768.png")).first
          layer = Magick::Image.read(Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path).first
          layer = CanvasPattern.fetch(:pattern_checker_grey_dark).func(self).copy
          layer.resize!(*image_rect) # 200 ms
          # layer.blur_image(20.0, 10.0)
          # layer = layer.emboss
          # layer = Magick::Image.read("netscape:").first.resize(*image_rect)
          layer = condition_then_flip(layer) # 全体を反転するので背景だけ反転しておくことで元に戻る
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

      def condition_then_color_negate(layer)
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

      # メモ化の効果なし
      def px(v)
        top_left + ps(v)
      end

      # pixel size
      def ps(v)
        v * cell_rect
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
        @image_rect ||= Rect.new(params[:width], params[:height])
      end

      def lattice
        @lattice ||= Rect.new(params[:dimension_w], params[:dimension_h])
      end

      def cell_w
        @cell_w ||= (vmin * params[:aspect_ratio_w]) / lattice.w
      end

      def cell_h
        @cell_h ||= (vmin * params[:aspect_ratio_h]) / lattice.h
      end

      # セルサイズの短い方
      def cell_vmin
        @cell_vmin ||= [cell_w, cell_h].min
      end

      def vmin
        @vmin ||= image_rect.to_a.min
      end

      def cell_rect
        @cell_rect ||= Rect.new(cell_w, cell_h)
      end

      def center
        @center ||= V[@s_canvas_layer.columns / 2, @s_canvas_layer.rows / 2]
      end

      def top_left
        @top_left ||= center - cell_rect * lattice / 2
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

      # portella, nureyon などの情報
      def piece_image_info
        @piece_image_info ||= PieceImageInfo.lookup(params[:piece_image_key])
      end
    end
  end
end
