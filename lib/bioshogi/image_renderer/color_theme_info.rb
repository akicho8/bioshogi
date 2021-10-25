require "color"

module Bioshogi
  class ImageRenderer
    class ColorThemeInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :is_color_theme_paper_simple,            func: -> e { e.is_color_theme_paper_simple }, },
        { key: :is_color_theme_paper_shape,             func: -> e { e.is_color_theme_paper_shape }, },

        { key: :is_color_theme_shogi_extend,            func: -> e { e.is_color_theme_shogi_extend.merge(piece_count_bg_color: "hsla(0,0%,0%,0.08)") }, },
        { key: :is_color_theme_style_editor,            func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(100,41%,80%)",  outer_frame_fill_color: "hsla(0,0%,0%,0.24)")  }, },
        { key: :is_color_theme_alpha_asahanada,  func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(195,41%,66%)",  outer_frame_fill_color: "hsla(0,0%,0%,0.15)")  }, },
        { key: :is_color_theme_alpha_asagi,      func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(188,100%,37%)", outer_frame_fill_color: "hsla(0,0%,0%,0.15)") }, },
        { key: :is_color_theme_alpha_usubudou,   func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(289,25%,71%)",  outer_frame_fill_color: "hsla(0,0%,0%,0.15)")  }, },
        { key: :is_color_theme_alpha_koiai,      func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(222,68%,19%)",  outer_frame_fill_color: "hsla(0,0%,100%,0.5)") }, },
        { key: :is_color_theme_alpha_kuromidori, func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(96,5%,20%)",    outer_frame_fill_color: "hsla(0,0%,100%,0.5)") }, },
        { key: :is_color_theme_alpha_kurobeni,   func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(284,12%,18%)",  outer_frame_fill_color: "hsla(0,0%,100%,0.5)") }, },
        { key: :is_color_theme_mario_sky,               func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(227,100%,71%)", outer_frame_fill_color: "hsla(0,0%,0%,0.22)")  }, },
        { key: :is_color_theme_club24,                  func: -> e { e.is_color_theme_shogi_extend.merge(canvas_bg_color: "hsl(84,62%,84%)",   outer_frame_fill_color: "hsl(40,66%,60%)")  }, },
        { key: :is_color_theme_piyo,                    func: -> e { e.is_color_theme_shogi_extend.merge(e.piyo_params) }, },

        { key: :is_color_theme_gradiention1,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention1.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_gradiention2,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention2.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_gradiention3,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention3.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_gradiention4,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention4.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_gradiention5,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention5.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_gradiention6,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/gradiention6.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },

        { key: :is_color_theme_plasma_blur1,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur1.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_plasma_blur2,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur2.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_plasma_blur3,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur3.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_plasma_blur4,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur4.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_plasma_blur5,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur5.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_plasma_blur6,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/plasma_blur6.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },

        { key: :is_color_theme_radial_gradiention1,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention1.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_radial_gradiention2,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention2.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_radial_gradiention3,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention3.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_radial_gradiention4,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention4.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_radial_gradiention5,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention5.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        # { key: :is_color_theme_radial_gradiention6,     func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/radial_gradiention6.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },

        { key: :is_color_theme_splatoon_stripe_red,      func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/splatoon_stripe_red.png",   outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_splatoon_stripe_green,    func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/splatoon_stripe_green.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },
        { key: :is_color_theme_splatoon_stripe_purple,    func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/splatoon_stripe_purple.png", outer_frame_fill_color: "hsla(0,0%,0%,0.22)") }, },

        { key: :is_color_theme_pattern_heart,            func: -> e { e.is_color_theme_shogi_extend.merge(bg_file: "#{__dir__}/../assets/images/background/pattern_heart.png", outer_frame_fill_color: "hsla(330,100%,71%,0.7)") }, },

        # { key: :is_color_theme_groovy_board_texture1,              func: -> e { e.real_wood_theme_core("pakutexture06210140") }, },
        # { key: :is_color_theme_real_wood2,              func: -> e { e.real_wood_theme_core("texture524_27") }, },
        # { key: :is_color_theme_real_wood3,              func: -> e { e.real_wood_theme_core("wood-texture_00018") }, },
        # { key: :is_color_theme_cg_wood1,                func: -> e { e.real_wood_theme_core("board_texture1") }, },
        # { key: :is_color_theme_cg_wood2,                func: -> e { e.real_wood_theme_core("board_texture2") }, },
        # { key: :is_color_theme_cg_wood3,                func: -> e { e.real_wood_theme_core("board_texture3") }, },
        # { key: :is_color_theme_cg_wood4,                func: -> e { e.real_wood_theme_core("board_texture4") }, },

        { key: :is_color_theme_groovy_board_texture1, func: -> e { e.real_wood_theme_core("groovy_board_texture1", "groovy_piece_texture_dark", "groovy_background_texture_dark") }, },
        { key: :is_color_theme_groovy_board_texture2, func: -> e { e.real_wood_theme_core("groovy_board_texture2", "groovy_piece_texture_dark", "groovy_background_texture_dark") }, },
        { key: :is_color_theme_groovy_board_texture3, func: -> e { e.real_wood_theme_core("groovy_board_texture3", "groovy_piece_texture_dark", "groovy_background_texture_dark") }, },
        { key: :is_color_theme_groovy_board_texture4, func: -> e { e.real_wood_theme_core("groovy_board_texture4", "groovy_piece_texture_light", "groovy_background_texture_light") }, },
        { key: :is_color_theme_groovy_board_texture5, func: -> e { e.real_wood_theme_core("groovy_board_texture5", "groovy_piece_texture_light", "groovy_background_texture_light") }, },
        { key: :is_color_theme_groovy_board_texture6, func: -> e { e.real_wood_theme_core("groovy_board_texture6", "groovy_piece_texture_light", "groovy_background_texture_light") }, },
        { key: :is_color_theme_wars_red,               func: -> e { e.real_wood_theme_core("groovy_board_texture_wars", "groovy_piece_texture_wars",  "checker_red_dark").merge(e.swars_like) }, },
        { key: :is_color_theme_wars_blue,              func: -> e { e.real_wood_theme_core("groovy_board_texture_wars", "groovy_piece_texture_wars", "checker_blue_dark").merge(e.swars_like) }, },

        # { key: :is_color_theme_groovy_board_texture7, func: -> e { e.real_wood_theme_core("groovy_board_texture7", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture8, func: -> e { e.real_wood_theme_core("groovy_board_texture8", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture9, func: -> e { e.real_wood_theme_core("groovy_board_texture9", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture10, func: -> e { e.real_wood_theme_core("groovy_board_texture10", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture11, func: -> e { e.real_wood_theme_core("groovy_board_texture11", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture12, func: -> e { e.real_wood_theme_core("groovy_board_texture12", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture13, func: -> e { e.real_wood_theme_core("groovy_board_texture13", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture14, func: -> e { e.real_wood_theme_core("groovy_board_texture14", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture15, func: -> e { e.real_wood_theme_core("groovy_board_texture15", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture16, func: -> e { e.real_wood_theme_core("groovy_board_texture16", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture17, func: -> e { e.real_wood_theme_core("groovy_board_texture17", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture18, func: -> e { e.real_wood_theme_core("groovy_board_texture18", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture19, func: -> e { e.real_wood_theme_core("groovy_board_texture19", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture20, func: -> e { e.real_wood_theme_core("groovy_board_texture20", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture21, func: -> e { e.real_wood_theme_core("groovy_board_texture21", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture22, func: -> e { e.real_wood_theme_core("groovy_board_texture22", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture23, func: -> e { e.real_wood_theme_core("groovy_board_texture23", "groovy_piece_texture_dark") }, },
        # { key: :is_color_theme_groovy_board_texture24, func: -> e { e.real_wood_theme_core("groovy_board_texture24", "groovy_piece_texture_dark") }, },

        { key: :is_color_theme_brightness_grey,         func: -> e { e.brightness_only_build(Color::GreyScale.from_fraction(0.7)) }, },
        { key: :is_color_theme_brightness_matrix,       func: -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; e.l = 0.6 }, alpha: 0.7) }, merge_params: { bg_file: "#{__dir__}/../assets/images/background/matrix.png" }, },
        { key: :is_color_theme_brightness_green,        func: -> e { e.brightness_only_build(Color::RGB::Green.to_hsl.tap  { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { key: :is_color_theme_brightness_orange,       func: -> e { e.brightness_only_build(Color::RGB::Orange.to_hsl.tap { |e| e.s = 1.0; e.l = 0.4 }) }, },
        { key: :is_color_theme_kimetsu_red,             func: -> e { e.kimetsu_build(Color::RGB::MediumVioletRed.adjust_saturation(60)) }, },
        { key: :is_color_theme_kimetsu_blue,            func: -> e { e.kimetsu_build(Color::RGB::LightSkyBlue.adjust_saturation(0))     }, },
      ]

      # 輝度だけを変化させた設定を返す
      def brightness_only_build(color, alpha: 0.92)
        base_color = color.to_rgb
        f = -> v { base_color.adjust_brightness(v).css_rgba(alpha) }
        {
          **piece_count_on_shadow_white_on_black(f),
          **outer_frame_padding_enabled,

          # :bg_file => "#{__dir__}/../assets/images/background/checker_grey_dark.png",

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

          # :canvas_pattern_key      => :pattern_checker_grey_dark,
          :bg_file => "#{__dir__}/../assets/images/background/checker_grey_dark.png",

          **{
            **pentagon_enabled,
            :piece_pentagon_fill_color   => komairo.html, # ☗の色(黄色)
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

      def is_color_theme_paper_simple
        {
          # 真っ白なので☖に枠をつける
          :face_pentagon_stroke_color => "hsla(0,0%,0%,0.4)",
          :face_pentagon_stroke_width => 1,
          **shadow_off,
        }
      end

      def is_color_theme_paper_shape
        {
          **pentagon_enabled,
          :piece_pentagon_fill_color   => "hsla(0,0%,100%,1.0)",
          :piece_pentagon_stroke_color => "hsla(0,0%,0%,0.4)",
          :piece_pentagon_stroke_width => 1,
          **shadow_off,
        }
      end

      def is_color_theme_shogi_extend
        {
          **piece_count_on_shadow_black_on_white,
          **outer_frame_padding_enabled,

          **{
            **pentagon_enabled,
            :piece_pentagon_stroke_width => nil,
          },

          # :bg_file                       => "#{__dir__}/../assets/images/background/checker_grey_light.png",
          # :bg_file                     => "#{__dir__}/../assets/images/background/matrix_1600x1200.png",

          # :canvas_pattern_key          => :pattern_checker_grey_light,

          :piece_font_color              => "hsla(0,0%,25%,1.0)",
          :promoted_font_color           => syuiro.html,
          :outer_frame_fill_color        => "hsla(0,0%,0%,0.2)", # "rgba(120,120,120,0.5)",
          :piece_move_cell_fill_color    => "hsla(0,0%,0%,0.1)",
          # :cell_colors                 => ["rgba(255,255,255,0.1)", nil],

          # 駒用
          :piece_pentagon_fill_color     => komairo.html,
          # :piece_pentagon_fill_color     => komairo.dup.tap { |e| e.luminosity = 10 }.html,
          # :piece_pentagon_fill_color     => komairo.dup.tap { |e| e.luminosity = 10 }.html,
          # :piece_pentagon_fill_color     => "hsl(52,76%,87%)",
          # :piece_pentagon_stroke_color   => "hsl(36,78%,50%)",  # ☗の縁取り色
          # :piece_pentagon_stroke_width   => 3,                  # ☗の縁取り幅

          # **piyo_params,
          # :canvas_bg_color             => "hsl(35,100% 85%)", # 背景
          # :outer_frame_fill_color      => "hsl(37,73%,68%)",  # 盤の色
          # :piece_pentagon_fill_color   => "hsl(52,76%,87%)",  # ☗の色
          # :piece_pentagon_stroke_color => "hsl(36,78%,50%)",  # ☗の縁取り色
          # :piece_pentagon_stroke_width => 1,                  # ☗の縁取り幅
          # :piece_pentagon_fill_color   => "hsl(43,100%,87%)",  # ☗の色
          # :piece_pentagon_stroke_color => "hsl(43,100%,50%)",   # ☗の縁取り色
          # :piece_pentagon_stroke_width => 0,                   # ☗の縁取り幅

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
            :black => "hsla(0,0%,23%,1.0)",
            :white => "hsla(0,0%,97%,1.0)",
          },
        }
      end

      def piyo_params
        {
          :canvas_bg_color             => "hsl(35,100% 85%)", # 背景
          :outer_frame_fill_color      => "hsl(37,73%,68%)",  # 盤の色
          :piece_pentagon_fill_color   => "hsl(52,76%,87%)",  # ☗の色
          :piece_pentagon_stroke_color => "hsl(36,78%,50%)",  # ☗の縁取り色
          :piece_pentagon_stroke_width => 3,                  # ☗の縁取り幅
          :face_pentagon_stroke_width  => 0,                  # ☗の縁取り幅(先後マーク)
        }
      end

      def real_wood_theme_core(fg_key, pt_key = "groovy_piece_texture_dark", bg_key = "checker_grey_dark")
        is_color_theme_shogi_extend.merge({
            :fg_file => "#{__dir__}/../assets/images/board/#{fg_key}.png",
            :pt_file => "#{__dir__}/../assets/images/piece/#{pt_key}.png",

            # :pt_file => Pathname("~/src/shogi-extend/nuxt_side/static/material/piece/0001.png").expand_path,

            # :bg_file              => "#{__dir__}/../assets/images/board/pakutexture06210140.png",
            # :canvas_bg_color        => "#fff5ca",
            # :canvas_bg_color        => komairo.adjust_brightness(12).css_rgb,
            # :bg_file => "#{__dir__}/../assets/images/background/checker_grey_dark.png",
            :bg_file => "#{__dir__}/../assets/images/background/#{bg_key}.png",

            # :piece_pentagon_fill_color   => "hsl(52,76%,87%)",  # ☗の色

            # # ここだけ特別に薄い黒の上に黒文字
            # :piece_count_bg_color   => "hsla(0,0%,0%,0.1)",
            # :piece_count_font_color => "hsla(0,0%,0%,0.5)",
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
            :single                    => [0.7, 0.08], # 駒数1桁のとき。[0, 0] なら該当の駒の中央
            :double                    => [0.7, 0.08], # 駒数2桁のとき
          },
          # :piece_count_bg_adjust => {
          #   :black => [-0.01, -0.01],
          #   :white => [-0.01, -0.01],
          # },
        }
      end

      def outer_frame_padding_enabled
        {
          :outer_frame_padding      => 0.1,
          :inner_frame_stroke_width => 1,
        }
      end

      def swars_like
        {
          :real_shadow_offset    => 3,
          :real_shadow_sigma     => 2.0,
          :real_shadow_opacity   => 0.9,

          :soldier_font_bold     => true,
          :stand_piece_font_bold => true,

          :piece_pentagon_scale  => 0.9,
          :soldier_font_scale    => 0.7,

          **swars_hutidori,
        }
      end

      def swars_hutidori
        {
          :piece_pentagon_stroke_color => "hsl(39,100%,68%)",  # ☗の縁取り色 (駒色とHSを合わせる) 元 [39, 1.00, 0.74]
          :piece_pentagon_stroke_width => 1,                   # ☗の縁取り幅
          :face_pentagon_stroke_width  => 0,                   # ☗の縁取り幅(先後マーク)
        }
      end

      def komairo
        @komairo ||= PaletteInfo.fetch("主用駒色").to_color
      end

      def syuiro
        @syuiro ||= PaletteInfo.fetch("主用朱色").to_color
      end

      def to_params
        @to_params ||= -> {
          func.call(self).merge(merge_params || {})
        }.call
      end

      def color_theme_cache_build(options = {})
        options = {
          verbose: false,
        }.merge(options)
        parser = Parser.parse(SFEN1)
        file = Pathname("#{__dir__}/../assets/images/color_theme_cache/#{key}.png").expand_path
        bin = parser.to_png(color_theme_key: key, width: 1920, height: 1080)
        FileUtils.makedirs(file.dirname)
        file.write(bin)
        if options[:verbose]
          puts file
        end
      end
    end
  end
end
