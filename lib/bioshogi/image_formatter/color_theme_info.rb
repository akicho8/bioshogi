require "color"

module Bioshogi
  class ImageFormatter
    class ColorThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          :key => :first_light_theme,
          :func => -> e {
            {
            }
          },
        },
        {
          :key => :pentagon_white_theme,
          :func => -> e {
            e.pentagon_white_theme
          },
        },

        {
          :key => :pentagon_basic_theme,
          :func => -> e {
            # e.pentagon_white_theme.merge({
            e.pentagon_basic_theme
          },
        },

        # {
        #   :key => :dark_theme,
        #   :func => -> e {
        #     {
        #       :face_pentagon_color     => { black: "#000", white: "#666", },
        #       :canvas_color      => "#222",         # 部屋の色
        #       :outer_frame_bg_color    => "#333",         # 盤の色
        #       :piece_color       => "#BBB",         # 駒の色
        #       :stand_piece_color => "#666",         # 駒の色(持駒)
        #       :piece_count_color => "#555",         # 駒の色(持駒数)
        #       :piece_move_bg_color      => "#444",         # 移動元と移動先のセルの背景色(nilなら描画しない)
        #       :lattice_color     => "#555",         # 格子の色
        #       :inner_frame_color       => "#585858",      # 格子の外枠色
        #       :promoted_font_color    => "#3c3",         # 成駒の色
        #     }
        #   },
        # },
        {
          :key => :dark_theme,
          :func => -> e {
            c = Color::GreyScale.from_fraction(0.7)
            e.bright_palette_for(c)
          },
        },
        {
          :key  => :matrix_theme,
          :func => -> e {
            c = Color::RGB::Green.to_hsl
            c.s = 1.0
            c.l = 0.6
            e.bright_palette_for(c, alpha: 0.7).merge(bg_file: "#{__dir__}/../assets/images/matrix_1024x768.png")
          },
        },
        {
          :key  => :green_lcd_theme,
          :func => -> e {
            c = Color::RGB::Green.to_hsl
            c.s = 1.0
            c.l = 0.4
            e.bright_palette_for(c)
          },
        },
        {
          :key => :orange_lcd_theme,
          :func => -> e {
            c = Color::RGB::Orange.to_hsl
            c.s = 1.0
            c.l = 0.4
            e.bright_palette_for(c)
          },
        },

        {
          :key => :flip_violet_red_theme,
          :func => -> e {
            c2 = Color::RGB::MediumVioletRed.adjust_saturation(50)
            e.flip_cell_type_for(c2)
          },
        },

        {
          :key => :flip_green_theme,
          :func => -> e {
            c2 = Color::RGB::Green.adjust_saturation(50)
            e.flip_cell_type_for(c2)
          },
        },
      ]

      # 輝度だけを変化させた設定を返す
      def bright_palette_for(color, alpha: 1.0)
        base_color = color.to_rgb
        bright_palette_for2(-> v { base_color.adjust_brightness(v).css_rgba(alpha) })
      end

      def bright_palette_for2(f)
        {
          **pentagon_enabled,
          **piece_count_on_shadow(f),
          **outer_frame_padding_enabled,

          :piece_pentagon_fill_color   => f[-80],
          :piece_pentagon_stroke_color => f[-50],
          :piece_pentagon_stroke_width => 2,

          :face_pentagon_color     => {
            black: f[-70],  # ☗
            white: f[20],   # ☖
          },
          :canvas_color        => f[-92],  # 部屋の色
          :outer_frame_bg_color => f[-84],  # 盤の色
          :cell_colors         => [f[-84], nil],  # セルの色
          :piece_move_bg_color => f[-70],  # 移動元と移動先のセルの背景色
          :lattice_color       => f[-40],  # 格子の色
          :inner_frame_color   => f[-30],  # 格子の外枠色
          :stand_piece_color   => f[-0],  # 駒の色(持駒)

          # 駒
          # :font_board_piece_bold => true,              # 駒は常に太字を使うか？
          :piece_color         => f[30],   # 駒の色
          :last_soldier_color  => f[70],   # 最後に動いた駒
          :promoted_font_color => f[50],   # 成駒の色
          # :normal_piece_color_map => {
          #   # :king   => f[50],
          #   # :rook   => f[50],
          #   # :bishop => f[50],
          #   # :gold   => f[-16],
          #   # :silver => f[-17],
          #   # :knight => f[-18],
          #   # :lance  => f[-19],
          #   # :pawn   => f[-20],
          # },
        }
      end

      def flip_cell_type_for(c2)
        c1 = Color::GreyScale.from_fraction(0.7).to_rgb
        f = -> v { c1.adjust_brightness(v).css_rgba(1.0) }

        # c2 = Color::RGB::IndianRed
        # c2 = Color::RGB::HotPink
        # c2 = Color::RGB::SeaGreen
        # c2 = Color::RGB::Green
        # c2 = Color::RGB::MediumVioletRed.adjust_saturation(50)
        r = -> v { c2.adjust_brightness(v).css_rgba(1.0) }

        {
          :face_pentagon_color     => {
            black: f[-70],  # ☗
            white: f[20],   # ☖
          },
          :canvas_color       => f[-84],  # 部屋の色
          :outer_frame_bg_color     => f[-78],  # 盤の色
          :cell_colors        => [f[-84], "transparent"],  # セルの色
          :piece_move_bg_color       => f[-68],  # 移動元と移動先のセルの背景色
          :stand_piece_color  => f[-30],  # 駒の色(持駒)
          :piece_count_color  => f[-50],  # 駒の色(持駒数)
          # :inner_frame_stroke_width => 3,

          :lattice_color      => r[-30],  # 格子の色
          :star_color         => r[  0],  # 星の色
          :inner_frame_color        => r[-30],  # 格子の外枠色

          # 駒
          :piece_color        => f[0],    # 駒の色
          :promoted_font_color     => f[30],   # 成駒の色
          :last_soldier_color => f[60],   # 最後に動いた駒
          :normal_piece_color_map => {
            :king   => f[50],
            :rook   => f[50],
            :bishop => f[50],
            :gold   => f[-10],
            :silver => f[-11],
            :knight => f[-12],
            :lance  => f[-13],
            :pawn   => f[-14],
          },
        }
      end

      def pentagon_white_theme
        {
          **pentagon_enabled,
          :piece_pentagon_fill_color   => "#fff",
          :piece_pentagon_stroke_color => "rgba(0,0,0,0.4)",
          :piece_pentagon_stroke_width => 1,
        }
      end

      def pentagon_basic_theme
        {
          **pentagon_enabled,
          **outer_frame_padding_enabled,

          # :canvas_pattern_key      => :pattern_checker_light,

          :piece_color            => "rgb(64,64,64)",
          :promoted_font_color    => "rgb(239,69,74)", # 朱色
          :outer_frame_bg_color         => "rgba(0,0,0,0.2)",
          :piece_move_bg_color    => "rgba(0,0,0,0.1)",
          # :cell_colors            => ["rgba(255,255,255,0.1)", nil],

          # 駒用
          :piece_pentagon_fill_color   => "rgb(255,227,156)", # ☗の色(黄色)
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
          :piece_char_scale     => 0.68,
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

      def to_params
        @to_params ||= func.call(self)
      end
    end
  end
end
