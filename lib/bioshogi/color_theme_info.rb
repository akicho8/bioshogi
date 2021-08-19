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
    def bright_palette_for(color)
      base_color = color.to_rgb
      adjust = -> v { base_color.adjust_brightness(v).html }
      {
        :hexagon_fill      => true,           # ☗を塗り潰して後手を表現するか？
        :hexagon_color     => {
          black: adjust[-70],  # ☗
          white: adjust[20],   # ☖
        },
        :canvas_color       => adjust[-92],  # 部屋の色
        :frame_bg_color     => adjust[-84],  # 盤の色
        :moving_color       => adjust[-70],  # 移動元と移動先のセルの背景色
        :lattice_color      => adjust[-40],  # 格子の色
        :frame_color        => adjust[-30],  # 格子の外枠色
        :stand_piece_color  => adjust[-30],  # 駒の色(持駒)
        :piece_count_color  => adjust[-50],  # 駒の色(持駒数)

        # 駒
        :piece_color        => adjust[0],    # 駒の色
        :last_soldier_color => adjust[70],   # 最後に動いた駒
        :promoted_color     => adjust[60],   # 成駒の色
        :normal_piece_color_map => {
          :king   => adjust[50],
          :rook   => adjust[50],
          :bishop => adjust[50],
          :gold   => adjust[-16],
          :silver => adjust[-17],
          :knight => adjust[-18],
          :lance  => adjust[-19],
          :pawn   => adjust[-20],
        },
      }
    end

    def to_params
      @to_params ||= func.call(self)
    end
  end
end
