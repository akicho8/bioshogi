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
            e.pentagon_default
          },
        },

        {
          :key => :pentagon_basic_theme,
          :func => -> e {
            e.pentagon_default.merge({
                # :canvas_pattern_key      => :pattern_checker_light,

                :piece_color           => "rgb(64,64,64)",
                :promoted_color        => "rgb(239,69,74)",
                :frame_bg_color        => "rgba(0,0,0,0.3)",
                :moving_color          => "rgba(0,0,0,0.1)",
                :cell_colors           => ["rgba(255,255,255,0.1)", nil],

                # 枠
                :outer_frame_padding      => 0.1,
                :inner_frame_stroke_width => 1,
                :inner_frame_color        => "rgba(0,0,0,0.4)",

                # 駒用
                :piece_pentagon_draw         => true,    # 駒の形を描画するか？
                :piece_pentagon_fill_color   => "rgb(255,227,156)", # ☗の色(黄色)
                :piece_pentagon_stroke_color => 0,       # ☗の縁取り色(nilなら lattice_color を代用)
                :piece_pentagon_stroke_width => 0,       # ☗の縁取り幅(nilなら lattice_stroke_width を代用)
                :piece_pentagon_scale        => 0.85,    # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
                :face_pentagon_scale       => 0.8,     # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

                :piece_char_scale      => 0.70,    # 盤上駒(piece_pentagon_scale より小さくする)
                :force_bold            => false,    # 常に太字を使うか？

                :piece_count_scale        => 0.6,  # 持駒数の大きさ
                :piece_count_color        => "rgba(0,0,0,0.4)",

                # :piece_count_stroke_color => "rgb(255,227,156)",  # 持駒数の縁取り色
                # :piece_count_stroke_color => "rgba(255,255,255,1.0)",  # 持駒数の縁取り色
                # :piece_count_stroke_width => 2,  # 持駒数の縁取り太さ

                # 影を入れるので☗を半透明にしない
                :shadow_pentagon_draw        => true,    # ☗の影を描画するか？
                :face_pentagon_color => {
                  :black => "rgba(  0,  0,  0)",  # ☗を白と黒で塗り分けるときの先手の色
                  :white => "rgba(255,255,255)",  # ☗を白と黒で塗り分けるときの後手の色
                },

                # 駒の中での文字の位置を調整する(少し下げないと違和感がある)
                :piece_char_adjust => {
                  :black => [ 0.05,  0.08],
                  :white => [-0.015, 0.03],
                },
              })
          },
        },

        # {
        #   :key => :dark_theme,
        #   :func => -> e {
        #     {
        #       :pentagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
        #       :face_pentagon_color     => { black: "#000", white: "#666", },
        #       :canvas_color      => "#222",         # 部屋の色
        #       :frame_bg_color    => "#333",         # 盤の色
        #       :piece_color       => "#BBB",         # 駒の色
        #       :stand_piece_color => "#666",         # 駒の色(持駒)
        #       :piece_count_color => "#555",         # 駒の色(持駒数)
        #       :moving_color      => "#444",         # 移動元と移動先のセルの背景色(nilなら描画しない)
        #       :lattice_color     => "#555",         # 格子の色
        #       :inner_frame_color       => "#585858",      # 格子の外枠色
        #       :promoted_color    => "#3c3",         # 成駒の色
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
            # e.bright_palette_for(c, alpha: 0.7).merge(bg_file: "#{__dir__}/assets/images/matrix_1600x1200.png")
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
          # :pentagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
          :face_pentagon_color     => {
            black: f[-70],  # ☗
            white: f[20],   # ☖
          },
          :canvas_color       => f[-92],  # 部屋の色
          :frame_bg_color     => f[-84],  # 盤の色
          :moving_color       => f[-70],  # 移動元と移動先のセルの背景色
          :lattice_color      => f[-40],  # 格子の色
          :inner_frame_color        => f[-30],  # 格子の外枠色
          :stand_piece_color  => f[-30],  # 駒の色(持駒)
          :piece_count_color  => f[-50],  # 駒の色(持駒数)

          # 駒
          :piece_color        => f[0],    # 駒の色
          :last_soldier_color => f[70],   # 最後に動いた駒
          :promoted_color     => f[60],   # 成駒の色
          :normal_piece_color_map => {
            :king   => f[50],
            :rook   => f[50],
            :bishop => f[50],
            :gold   => f[-16],
            :silver => f[-17],
            :knight => f[-18],
            :lance  => f[-19],
            :pawn   => f[-20],
          },
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
          # :pentagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
          :face_pentagon_color     => {
            black: f[-70],  # ☗
            white: f[20],   # ☖
          },
          :canvas_color       => f[-84],  # 部屋の色
          :frame_bg_color     => f[-78],  # 盤の色
          :cell_colors        => [f[-84], "transparent"],  # セルの色
          :moving_color       => f[-68],  # 移動元と移動先のセルの背景色
          :stand_piece_color  => f[-30],  # 駒の色(持駒)
          :piece_count_color  => f[-50],  # 駒の色(持駒数)
          # :inner_frame_stroke_width => 3,

          :lattice_color      => r[-30],  # 格子の色
          :star_color         => r[  0],  # 星の色
          :inner_frame_color        => r[-30],  # 格子の外枠色

          # 駒
          :piece_color        => f[0],    # 駒の色
          :promoted_color     => f[30],   # 成駒の色
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

      def pentagon_default
        {
          # 駒用
          :piece_pentagon_draw         => true,    # 駒の形を描画するか？
          :piece_pentagon_fill_color   => "white", # ☗の色
          :piece_pentagon_stroke_color => "#888",  # ☗の縁取り色(nilなら lattice_color を代用)
          :piece_pentagon_stroke_width => 2,       # ☗の縁取り幅(nilなら lattice_stroke_width を代用)
          :piece_pentagon_scale        => 0.85,    # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
          :face_pentagon_scale       => 0.8,     # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

          :piece_char_scale      => 0.75,    # 盤上駒(piece_pentagon_scale より小さくする)
          :force_bold            => true,    # 常に太字を使うか？

          # 駒の中での文字の位置を調整する(少し下げないと違和感がある)
          :piece_char_adjust => {
            :black => [ 0.0425, 0.08],
            :white => [-0.015,  0.03],
          },
        }
      end

      def to_params
        @to_params ||= func.call(self)
      end
    end
  end
end
