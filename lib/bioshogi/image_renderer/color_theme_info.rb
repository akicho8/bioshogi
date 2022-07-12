require "color"

module Bioshogi
  class ImageRenderer
    class ColorThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :is_color_theme_real,   },
        { key: :is_color_theme_piyo,   },
        { key: :is_color_theme_paper,  },
        { key: :is_color_theme_shape,  },
        { key: :is_color_theme_club24, },
      ]

      ################################################################################

      def to_params
        @to_params ||= send(key)
      end

      def color_theme_cache_build(options = {})
        options = {
          verbose: false,
        }.merge(options)
        parser = Parser.parse(SFEN1)
        file = Pathname("#{__dir__}/../assets/images/color_theme_preview/#{key}.png").expand_path
        bin = parser.to_png(color_theme_key: key, width: 1920, height: 1080)
        FileUtils.makedirs(file.dirname)
        file.write(bin)
        if options[:verbose]
          puts file
        end
      end

      ################################################################################

      def is_color_theme_real
        is_color_theme_shogi_extend.merge({
            :fg_file => "#{__dir__}/../assets/images/board/board1.png",
            :bg_file => "#{__dir__}/../assets/images/background/background1.png",
            :piece_image_key => "Portella",
          })
      end

      def is_color_theme_paper
        {
          :face_pentagon_stroke_width => 1, # ☗の縁取り幅(先後マーク)
          **shadow_disabled,
        }
      end

      def is_color_theme_shape
        {
          **pentagon_enabled,
          **shadow_disabled,
          :piece_pentagon_fill_color   => "hsla(0,0%,100%,1.0)",
          :piece_pentagon_stroke_color => "hsla(0,0%,0%,0.4)",
          :piece_pentagon_stroke_width => 1,
          :face_pentagon_stroke_width  => 1, # ☗の縁取り幅(先後マーク)
        }
      end

      def is_color_theme_club24
        is_color_theme_shogi_extend.merge({
            :canvas_bg_color        => "hsl(84,62%,84%)",
            :outer_frame_fill_color => "hsl(39,66%,60%)",
          })
      end

      def is_color_theme_piyo
        is_color_theme_shogi_extend.merge({
            :canvas_bg_color             => "hsl(35,100% 85%)", # 背景
            :outer_frame_fill_color      => "hsl(37,73%,68%)",  # 盤の色
            :piece_pentagon_fill_color   => "hsl(52,76%,87%)",  # ☗の色
            :piece_pentagon_stroke_color => "hsl(36,78%,50%)",  # ☗の縁取り色
            :piece_pentagon_stroke_width => 3,                  # ☗の縁取り幅
            :face_pentagon_stroke_width  => 0,                  # ☗の縁取り幅(先後マーク)
          })
      end

      private

      def is_color_theme_shogi_extend
        {
          **piece_count_on_shadow_black_on_white,
          **outer_frame_padding_enabled,
          **pentagon_enabled,
          :piece_font_color           => "hsla(0,0%,25%,1.0)",
          :promoted_font_color        => PaletteInfo.fetch("主用朱色").to_color.html,
          :outer_frame_fill_color     => "hsla(0,0%,0%,0.2)", # "rgba(120,120,120,0.5)",
          :piece_move_cell_fill_color => "hsla(0,0%,0%,0.1)",
          :piece_pentagon_fill_color  => PaletteInfo.fetch("主用駒色").to_color.html,
        }
      end

      # 六角形の駒にする
      def pentagon_enabled
        {
          :piece_pentagon_draw => true,
          :soldier_font_scale  => 0.64,
          :piece_char_adjust => {
            :black => [ 0.0425, 0.08],
            :white => [-0.01,   0.05],
          },
        }
      end

      # 影OFF
      def shadow_disabled
        {
          :real_shadow_sigma => 0, # 影を取る
        }
      end

      # 持駒駒数
      def piece_count_on_shadow_black_on_white
        {
          :piece_count_bg_scale        => 0.3,         # 駒数の背景の大きさ
          :piece_count_font_scale      => 0.25,        # 持駒数の大きさ
          :piece_count_position_adjust => {            # 駒数の位置
            :single                    => [0.7, 0.08], # 駒数1桁のとき。[0, 0] なら該当の駒の中央
            :double                    => [0.7, 0.08], # 駒数2桁のとき
          },
        }
      end

      # 盤の周囲に隙間を作る
      def outer_frame_padding_enabled
        {
          :outer_frame_padding      => 0.1,
          :inner_frame_stroke_width => 1,
        }
      end
    end
  end
end
