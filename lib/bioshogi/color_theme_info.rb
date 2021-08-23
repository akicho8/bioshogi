require "color"

module Bioshogi
  class ColorThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        :key => :light_mode,
        :func => -> e {
          {
          }
        },
      },
      # {
      #   :key => :dark_mode,
      #   :func => -> e {
      #     {
      #       :hexagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
      #       :hexagon_color     => { black: "#000", white: "#666", },
      #       :canvas_color      => "#222",         # 部屋の色
      #       :frame_bg_color    => "#333",         # 盤の色
      #       :piece_color       => "#BBB",         # 駒の色
      #       :stand_piece_color => "#666",         # 駒の色(持駒)
      #       :piece_count_color => "#555",         # 駒の色(持駒数)
      #       :moving_color      => "#444",         # 移動元と移動先のセルの背景色(nilなら描画しない)
      #       :lattice_color     => "#555",         # 格子の色
      #       :frame_color       => "#585858",      # 格子の外枠色
      #       :promoted_color    => "#3c3",         # 成駒の色
      #     }
      #   },
      # },
      {
        :key => :dark_mode,
        :func => -> e {
          c = Color::GreyScale.from_fraction(0.7)
          e.bright_palette_for(c)
        },
      },
      {
        :key  => :matrix_mode,
        :func => -> e {
          c = Color::RGB::Green.to_hsl
          c.s = 1.0
          c.l = 0.6
          # e.bright_palette_for(c, alpha: 0.7).merge(bg_file: "#{__dir__}/assets/images/matrix_1600x1200.png")
          e.bright_palette_for(c, alpha: 0.7).merge(bg_file: "#{__dir__}/assets/images/matrix_1024x768.png")
        },
      },
      {
        :key  => :green_lcd_mode,
        :func => -> e {
          c = Color::RGB::Green.to_hsl
          c.s = 1.0
          c.l = 0.4
          e.bright_palette_for(c)
        },
      },
      {
        :key => :orange_lcd_mode,
        :func => -> e {
          c = Color::RGB::Orange.to_hsl
          c.s = 1.0
          c.l = 0.4
          e.bright_palette_for(c)
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
        :hexagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
        :hexagon_color     => {
          black: f[-70],  # ☗
          white: f[20],   # ☖
        },
        :canvas_color       => f[-92],  # 部屋の色
        :frame_bg_color     => f[-84],  # 盤の色
        :moving_color       => f[-70],  # 移動元と移動先のセルの背景色
        :lattice_color      => f[-40],  # 格子の色
        :frame_color        => f[-30],  # 格子の外枠色
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

    def to_params
      @to_params ||= func.call(self)
    end
  end
end
