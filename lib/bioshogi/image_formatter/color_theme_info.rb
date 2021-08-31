require "color"

module Bioshogi
  class ImageFormatter
    class ColorThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        { :key => :paper_simple_theme,      :func => -> e { { } }, },
        { :key => :paper_shape_theme,       :func => -> e { e.paper_shape_theme }, },
        { :key => :shogi_extend_theme,      :func => -> e { e.shogi_extend_theme }, },
        { :key => :brightness_grey_theme,   :func => -> e { e.brightness_only_build(Color::GreyScale.from_fraction(0.7)) }, },
        { :key => :brightness_matrix_theme, :func => -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; s.l = 0.6 }, alpha: 0.7) }, :merge_params => { bg_file: "#{__dir__}/../assets/images/matrix_1600x1200.png" }, },
        { :key => :brightness_green_theme,  :func => -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { :key => :brightness_orange_theme, :func => -> e { e.brightness_only_build(Color::RGB::Orange.to_hsl.tap { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { :key => :kimetsu_red_theme,       :func => -> e { e.kimetsu_build(Color::RGB::MediumVioletRed.adjust_saturation(60)) }, },
        { :key => :kimetsu_blue_theme,      :func => -> e { e.kimetsu_build(Color::RGB::LightSkyBlue.adjust_saturation(0))     }, },
      ]

      # 輝度だけを変化させた設定を返す
      def brightness_only_build(color, alpha: 1.0)
        base_color = color.to_rgb
        f = -> v { base_color.adjust_brightness(v).css_rgba(alpha) }
        {
          **piece_count_on_shadow(f),
          **outer_frame_padding_enabled,

          # :bg_file => "#{__dir__}/../assets/images/checker_dark.png",

          **{
            **pentagon_enabled,
            :piece_pentagon_fill_color   => f[-80],
            :piece_pentagon_stroke_color => f[-50],
            :piece_pentagon_stroke_width => 2,
          },

          :face_pentagon_color           => {
            black: f[-70],                                 # ☗
            white: f[20],                                  # ☖
          },
          :canvas_color                  => f[-92],        # 部屋の色
          :outer_frame_fill_color        => f[-84],        # 盤の色
          :cell_colors                   => [f[-84], nil], # セルの色
          :piece_move_cell_fill_color    => f[-70],        # 移動元と移動先のセルの背景色
          :lattice_color                 => f[-40],        # 格子の色
          :inner_frame_stroke_color      => f[-30],        # 格子の外枠色
          :stand_piece_color             => f[-0],         # 駒の色(持駒)

                                                           # 駒
                                                           # :font_board_piece_bold       => true,              # 駒は常に太字を使うか？
          :piece_font_color              => f[30],         # 駒の色
          :last_soldier_font_color       => f[70],         # 最後に動いた駒
          :promoted_font_color           => f[50],         # 成駒の色
                                                           # :normal_piece_color_map      => {
                                                           #   # :king                    => f[50],
                                                           #   # :rook                    => f[50],
                                                           #   # :bishop                  => f[50],
                                                           #   # :gold                    => f[-16],
                                                           #   # :silver                  => f[-17],
                                                           #   # :knight                  => f[-18],
                                                           #   # :lance                   => f[-19],
                                                           #   # :pawn                    => f[-20],
                                                           # },
        }
      end

      def kimetsu_build(accent_color)
        c1 = Color::GreyScale.from_fraction(0.8).to_rgb
        f = -> v { c1.adjust_brightness(v).css_rgba(1.0) }

        # accent_color = Color::RGB::IndianRed
        # accent_color = Color::RGB::HotPink
        # accent_color = Color::RGB::SeaGreen
        # accent_color = Color::RGB::Green
        # accent_color = Color::RGB::MediumVioletRed.adjust_saturation(50)
        r = -> v { accent_color.adjust_brightness(v).css_rgba(1.0) }

        {
          **piece_count_on_shadow(f),

          **{
            **outer_frame_padding_enabled,
            :outer_frame_padding => 0.05,
          },

          # :canvas_pattern_key      => :pattern_checker_dark,
          :bg_file => "#{__dir__}/../assets/images/checker_dark.png",

          **{
            **pentagon_enabled,
            :piece_pentagon_fill_color   => komairo.adjust_saturation(0).html, # ☗の色(黄色)
            :piece_pentagon_stroke_color => "transparent",
            :piece_pentagon_stroke_width => 0,
            :shadow_pentagon_draw        => true,    # ☗の影を描画するか？
          },

          :face_pentagon_color           => {
            black: f[-65],                                      # ☗
            white: f[-30],                                      # ☖
          },
          :canvas_color                  => f[-75],             # 部屋の色
          :outer_frame_fill_color        => f[-65],             # 盤の色
          :cell_colors                   => [nil, f[-75]],      # セルの色
          :piece_move_cell_fill_color    => r[-60],             # 移動元と移動先のセルの背景色

          :piece_count_color             => f[-40],             # 駒の色(持駒数)

          # 駒
          :piece_font_color              => f[-75],             # 駒の色
          :promoted_font_color           => syuiro.html,

          :lattice_color                 => r[-20],             # 格子の色
          :star_color                    => r[  0],             # 星の色
          :inner_frame_stroke_color      => r[-20],             # 格子の外枠色
          :outer_frame_stroke_color      => r[-20],             # 格子の外枠色
          :outer_frame_stroke_width      => 1,
        }
      end

      def paper_shape_theme
        {
          **pentagon_enabled,
          :piece_pentagon_fill_color   => "#fff",
          :piece_pentagon_stroke_color => "rgba(0,0,0,0.4)",
          :piece_pentagon_stroke_width => 1,
        }
      end

      def shogi_extend_theme
        {
          **pentagon_enabled,
          **outer_frame_padding_enabled,

          :bg_file => "#{__dir__}/../assets/images/checker_light.png",

          # :canvas_pattern_key      => :pattern_checker_light,

          :piece_font_color            => "rgb(64,64,64)",
          :promoted_font_color         => syuiro.html,
          :outer_frame_fill_color         => "rgba(0,0,0,0.2)",
          :piece_move_cell_fill_color    => "rgba(0,0,0,0.1)",
          # :cell_colors            => ["rgba(255,255,255,0.1)", nil],

          # 駒用
          :piece_pentagon_fill_color   => komairo.html,
          # :piece_pentagon_stroke_color => 0,                  # ☗の縁取り色(nilなら lattice_color を代用)
          # :piece_pentagon_stroke_width => 0,                  # ☗の縁取り幅(nilなら lattice_stroke_width を代用)

          # :font_board_piece_bold       => false,              # 駒は常に太字を使うか？

          # 持駒
          :piece_count_color           => "rgba(0,0,0,0.4)",

          # :piece_count_stroke_color => "rgb(255,227,156)",  # 持駒数の縁取り色
          # :piece_count_stroke_color => "rgba(255,255,255,1.0)",  # 持駒数の縁取り色
          # :piece_count_stroke_width => 2,  # 持駒数の縁取り太さ

          # 影を入れるので☗を半透明にしない
          :shadow_pentagon_draw        => true,    # ☗の影を描画するか？
          :face_pentagon_color => {
            :black => "rgba(  0,  0,  0)",  # ☗を白と黒で塗り分けるときの先手の色
            :white => "rgba(255,255,255)",  # ☗を白と黒で塗り分けるときの後手の色
          },
        }
      end

      def pentagon_enabled
        {
          :piece_pentagon_draw => true,
          :face_pentagon_scale  => 0.80,
          :piece_pentagon_scale => 0.85,
          :piece_char_scale     => 0.64,
          :piece_char_adjust => {
            :black => [ 0.0425, 0.08],
            :white => [-0.01,   0.05],
          },
        }
      end

      def piece_count_on_shadow(f)
        {
          :piece_count_bg_color        => f[-84],      # 駒数の背景
          :piece_count_color           => f[-30],      # 駒の色(持駒数)
          :piece_count_bg_scale        => 0.4,         # 駒数の背景の大きさ
          :piece_count_scale           => 0.35,        # 持駒数の大きさ
          :piece_count_position_adjust => {            # 駒数の位置
            :single                    => [0.8, 0.05], # 駒数1桁のとき。[0, 0] なら該当の駒の中央
            :double                    => [0.9, 0.05], # 駒数2桁のとき
          },
          :piece_count_bg_adjust => {
            :black => [-0.02, -0.02],
            :white => [-0.03, -0.01],
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

      def to_params
        @to_params ||= -> {
          func.call(self).merge(merge_params || {})
        }.call
      end
    end
  end
end
