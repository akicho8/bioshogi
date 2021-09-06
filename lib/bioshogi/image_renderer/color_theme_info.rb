require "color"

module Bioshogi
  class ImageRenderer
    class ColorThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        { :key => :paper_simple_theme,         :func => -> e { e.paper_simple_theme }, },
        { :key => :paper_shape_theme,          :func => -> e { e.paper_shape_theme }, },
        { :key => :shogi_extend_theme,         :func => -> e { e.shogi_extend_theme }, },
        { :key => :style_editor_theme,         :func => -> e { e.style_editor_theme }, },
        { :key => :style_editor_blue_theme,    :func => -> e { e.style_editor_blue_theme }, },
        { :key => :style_editor_pink_theme,    :func => -> e { e.style_editor_pink_theme }, },
        { :key => :style_editor_kon_theme,     :func => -> e { e.style_editor_kon_theme }, },
        { :key => :youtube_red_theme,          :func => -> e { e.youtube_red_theme }, },
        { :key => :mario_sky_theme,            :func => -> e { e.mario_sky_theme }, },
        { :key => :splatoon_red_black_theme,   :func => -> e { e.splatoon_red_black_theme }, },
        { :key => :splatoon_green_black_theme, :func => -> e { e.splatoon_green_black_theme }, },
        { :key => :real_wood_theme1,           :func => -> e { e.real_wood_theme_core("pakutexture06210140") }, },
        { :key => :real_wood_theme2,           :func => -> e { e.real_wood_theme_core("texture524_27") }, },
        { :key => :real_wood_theme3,           :func => -> e { e.real_wood_theme_core("wood-texture_00018") }, },
        { :key => :brightness_grey_theme,      :func => -> e { e.brightness_only_build(Color::GreyScale.from_fraction(0.7)) }, },
        { :key => :brightness_matrix_theme,    :func => -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; e.l = 0.6 }, alpha: 0.7) }, :merge_params => { bg_file: "#{__dir__}/../assets/images/matrix_1920x1080.png" }, },
        { :key => :brightness_green_theme,     :func => -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { :key => :brightness_orange_theme,    :func => -> e { e.brightness_only_build(Color::RGB::Orange.to_hsl.tap { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { :key => :kimetsu_red_theme,          :func => -> e { e.kimetsu_build(Color::RGB::MediumVioletRed.adjust_saturation(60)) }, },
        { :key => :kimetsu_blue_theme,         :func => -> e { e.kimetsu_build(Color::RGB::LightSkyBlue.adjust_saturation(0))     }, },
      ]

      # 輝度だけを変化させた設定を返す
      def brightness_only_build(color, alpha: 0.92)
        base_color = color.to_rgb
        f = -> v { base_color.adjust_brightness(v).css_rgba(alpha) }
        {
          **piece_count_on_shadow_white_on_black(f),
          **outer_frame_padding_enabled,

          # :bg_file => "#{__dir__}/../assets/images/checker_dark.png",

          **{
            **pentagon_enabled,
            :piece_pentagon_fill_color   => f[-70],
            :piece_pentagon_stroke_color => f[-55],
            :piece_pentagon_stroke_width => 2,
          },
          :canvas_bg_color                  => f[-88],        # 部屋の色
          :outer_frame_fill_color        => f[-84],        # 盤の色
          :piece_move_cell_fill_color    => f[-81],        # 移動元と移動先のセルの背景色
          :inner_frame_lattice_color                 => f[-40],        # 格子の色
          :inner_frame_stroke_color      => f[-30],        # 格子の外枠色

          # 駒
          :piece_font_color              => f[20],         # 駒の色
          :last_soldier_font_color       => f[70],         # 最後に動いた駒
          :promoted_font_color           => f[50],         # 成駒の色

          :face_pentagon_color           => {
            black: f[-70],      # ☗
            white: f[20],       # ☖
          },
        }
      end

      def kimetsu_build(accent_color)
        c1 = Color::GreyScale.from_fraction(0.8).to_rgb
        f = -> v { c1.adjust_brightness(v).css_rgba(0.92) }

        # accent_color = Color::RGB::IndianRed
        # accent_color = Color::RGB::HotPink
        # accent_color = Color::RGB::SeaGreen
        # accent_color = Color::RGB::Green
        # accent_color = Color::RGB::MediumVioletRed.adjust_saturation(50)
        r = -> v { accent_color.adjust_brightness(v).css_rgba(1.0) }

        {
          **{
            # **piece_count_on_shadow_white_on_black(f),
            **piece_count_on_shadow_black_on_white,
          },

          **{
            **outer_frame_padding_enabled,
            :outer_frame_padding => 0.05,
          },

          # :canvas_pattern_key      => :pattern_checker_dark,
          :bg_file => img_path("checker_dark.png"),

          **{
            **pentagon_enabled,
            :piece_pentagon_fill_color   => komairo.adjust_saturation(0).html, # ☗の色(黄色)
            :piece_pentagon_stroke_color => "transparent",
            :piece_pentagon_stroke_width => 0,
            # :shadow_pentagon_draw        => true,    # ☗の影を描画するか？
          },

          :face_pentagon_color           => {
            black: f[-65],                                      # ☗
            white: f[-30],                                      # ☖
          },
          :canvas_bg_color                  => f[-75],             # 部屋の色
          :outer_frame_fill_color        => f[-65],             # 盤の色
          :cell_colors                   => [nil, f[-75]],      # セルの色
          :piece_move_cell_fill_color    => r[-60],             # 移動元と移動先のセルの背景色

          # 駒
          :piece_font_color              => f[-75],             # 駒の色
          :promoted_font_color           => syuiro.html,

          :inner_frame_lattice_color                 => r[-20],             # 格子の色
          :star_fill_color                    => r[  0],             # 星の色
          :inner_frame_stroke_color      => r[-20],             # 格子の外枠色
          :outer_frame_stroke_color      => r[-20],             # 格子の外枠色
          :outer_frame_stroke_width      => 1,
        }
      end

      def paper_simple_theme
        {
          # 真っ白なので☖に枠をつける
          :face_pentagon_stroke_color => "rgba(0,0,0,0.4)",
          :face_pentagon_stroke_width => 1,
          **shadow_off,
        }
      end

      def paper_shape_theme
        {
          **pentagon_enabled,
          :piece_pentagon_fill_color   => "#fff",
          :piece_pentagon_stroke_color => "rgba(0,0,0,0.4)",
          :piece_pentagon_stroke_width => 1,
          **shadow_off,
        }
      end

      def shogi_extend_theme
        {
          **piece_count_on_shadow_black_on_white,
          **outer_frame_padding_enabled,

          **{
            **pentagon_enabled,
            :piece_pentagon_stroke_width => nil,
          },

          # :bg_file                       => "#{__dir__}/../assets/images/checker_light.png",
          # :bg_file                     => "#{__dir__}/../assets/images/matrix_1600x1200.png",

          # :canvas_pattern_key          => :pattern_checker_light,

          :piece_font_color              => "rgb(64,64,64)",
          :promoted_font_color           => syuiro.html,
          :outer_frame_fill_color        => "rgba(0,0,0,0.2)", # "rgba(120,120,120,0.5)",
          :piece_move_cell_fill_color    => "rgba(0,0,0,0.1)",
          # :cell_colors                 => ["rgba(255,255,255,0.1)", nil],

          # 駒用
          :piece_pentagon_fill_color     => komairo.html,

          # :piece_pentagon_stroke_color => 0,                  # ☗の縁取り色(nilなら inner_frame_lattice_color を代用)
          # :piece_pentagon_stroke_width => 0,                  # ☗の縁取り幅(nilなら lattice_stroke_width を代用)

          # :soldier_font_bold       => false,              # 駒は常に太字を使うか？

          # 持駒

          # :piece_count_stroke_color    => "rgb(255,227,156)",  # 持駒数の縁取り色
          # :piece_count_stroke_color    => "rgba(255,255,255,1.0)",  # 持駒数の縁取り色
          # :piece_count_stroke_width    => 2,  # 持駒数の縁取り太さ

          # 影を入れるので☗を半透明にしない
          # :shadow_pentagon_draw          => true,    # ☗の影を描画するか？
          :face_pentagon_color         => {
            :black => "rgb( 60, 60, 60)",
            :white => "rgb(248,248,248)",
          },
        }
      end

      def style_editor_theme
        shogi_extend_theme.merge({
            # :bg_file                => nil,
            :canvas_bg_color        => "rgb(197,225,183)",
            :outer_frame_fill_color => "rgba(0,0,0,0.24)",
          })
      end

      def style_editor_blue_theme
        shogi_extend_theme.merge({
            # :bg_file                => nil,
            :canvas_bg_color        => "#d9fffc",
            :outer_frame_fill_color => "rgba(0,0,0,0.15)",

            # ここだけ特別に薄い黒の上に黒文字
            # :piece_count_bg_color   => "rgba(0,0,0,0.1)",
            # :piece_count_font_color => "rgba(0,0,0,0.5)",

          })
      end

      def style_editor_pink_theme
        shogi_extend_theme.merge({
            # :bg_file                => nil,
            :canvas_bg_color        => "hsl(327,100%,92%)",
            :outer_frame_fill_color => "rgba(0,0,0,0.15)",
          })
      end

      def style_editor_kon_theme
        shogi_extend_theme.merge({
            :canvas_bg_color        => "hsl(221,62%,36%)",      # 紺色に
            :outer_frame_fill_color => "hsla(0,0,100%,0.5)",
          })
      end

      def youtube_red_theme
        shogi_extend_theme.merge({
            :canvas_bg_color        => "hsl(356,81%,47%)",
            :outer_frame_fill_color => "hsla(0,0,0%,0.2)",
          })
      end

      def mario_sky_theme
        shogi_extend_theme.merge({
            :canvas_bg_color        => "hsl(227,100%,71%)",
            :outer_frame_fill_color => "hsla(0,0,0%,0.22)",
          })
      end

      def splatoon_red_black_theme
        shogi_extend_theme.merge({
            :bg_file                => "#{__dir__}/../assets/images/splatoon_red_stripe.png",
            # :canvas_bg_color        => "hsl(337,73%,51%)",   # 単色の場合
            :outer_frame_fill_color => "hsla(0,0,0%,0.22)",
          })
      end

      def splatoon_green_black_theme
        shogi_extend_theme.merge({
            :bg_file                => "#{__dir__}/../assets/images/splatoon_green_stripe.png",
            # :canvas_bg_color        => "hsl(120,80%,43%)",   # 単色の場合
            :outer_frame_fill_color => "hsla(0,0,0%,0.22)",
          })
      end

      def real_wood_theme_core(name)
        shogi_extend_theme.merge({
            :battle_field_texture => "#{__dir__}/../assets/images/board/#{name}.png",
            # :bg_file              => "#{__dir__}/../assets/images/board/pakutexture06210140.png",

            # :canvas_bg_color        => "#fff5ca",
            :canvas_bg_color        => komairo.adjust_brightness(12).css_rgb,

            # # ここだけ特別に薄い黒の上に黒文字
            # :piece_count_bg_color   => "rgba(0,0,0,0.1)",
            # :piece_count_font_color => "rgba(0,0,0,0.5)",
          })
      end

      def pentagon_enabled
        {
          :piece_pentagon_draw => true,
          :soldier_font_scale => 0.64,
          :piece_char_adjust => {
            :black => [ 0.0425, 0.08],
            :white => [-0.01,   0.05],
          },
        }
      end

      def shadow_off
        {
          # 影を取る
          :real_shadow_sigma => 0,
        }
      end

      # def piece_count_on_shadow_white_on_black2(fraction = 0.8, alpha = 0.92)
      #   c = Color::GreyScale.from_fraction(fraction).to_rgb
      #   f = -> v { c.adjust_brightness(v).css_rgba(alpha) }
      #   piece_count_on_shadow_white_on_black(f)
      # end

      def piece_count_on_shadow_white_on_black(f)
        {
          **piece_count_on_shadow_black_on_white,
          :piece_count_bg_color   => f[-88],      # 駒数の背景
          :piece_count_font_color => f[-10],      # 駒の色(持駒数)
        }
      end

      def piece_count_on_shadow_black_on_white
        # {
        #   :piece_count_bg_scale        => 0.4,         # 駒数の背景の大きさ
        #   :piece_count_font_scale      => 0.35,        # 持駒数の大きさ
        #   :piece_count_position_adjust => {            # 駒数の位置
        #     :single                    => [0.8, 0.05], # 駒数1桁のとき。[0, 0] なら該当の駒の中央
        #     :double                    => [0.9, 0.05], # 駒数2桁のとき
        #   },
        #   :piece_count_bg_adjust => {
        #     :black => [-0.02, -0.02],
        #     :white => [-0.03, -0.01],
        #   },
        # }

        # 小さめ
        {
          :piece_count_bg_scale        => 0.3,         # 駒数の背景の大きさ
          :piece_count_font_scale      => 0.25,        # 持駒数の大きさ
          :piece_count_position_adjust => {            # 駒数の位置
            :single                    => [0.7, 0.05], # 駒数1桁のとき。[0, 0] なら該当の駒の中央
            :double                    => [0.7, 0.05], # 駒数2桁のとき
          },
          :piece_count_bg_adjust => {
            :black => [-0.02, -0.02],
            :white => [-0.03, -0.02],
          },
        }
      end

      def outer_frame_padding_enabled
        {
          :outer_frame_padding      => 0.1,
          :inner_frame_stroke_width => 1,
        }
      end

      def komairo
        Color::RGB.new(255, 227, 156)
      end

      def syuiro
        Color::RGB.new(239, 69, 74)
      end

      def img_path(name)
        "#{__dir__}/../assets/images/#{name}"
      end

      def to_params
        @to_params ||= -> {
          func.call(self).merge(merge_params || {})
        }.call
      end
    end
  end
end
