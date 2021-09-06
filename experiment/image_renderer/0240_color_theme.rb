require "../example_helper"
require "color"

parser = Parser.parse("position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1")
bg_file = "../../lib/bioshogi/assets/images/checker_light.png"
bg_file = "../../lib/bioshogi/assets/images/board/original/pakutexture06210140.jpg"
bg_file = Pathname("~/Pictures/ぱくたそ/Redsugar20207061_TP_V.jpg").expand_path.to_s
bg_file = Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path.to_s
bg_file = nil

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key).display }

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key, renderer_override_params: {bg_file: bg_file}).display }

# parser.image_renderer(color_theme_key: "real_wood_theme1", renderer_override_params: {battle_field_texture: bg_file, bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "real_wood_theme1", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "real_wood_theme2").display
# parser.image_renderer(color_theme_key: "real_wood_theme3").display
# parser.image_renderer(color_theme_key: "paper_simple_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "paper_shape_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "shogi_extend_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "style_editor_theme").display
# parser.image_renderer(color_theme_key: "style_editor_blue_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "style_editor_pink_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "style_editor_kon_theme", renderer_override_params: {bg_file: bg_file}).display
parser.image_renderer(color_theme_key: "youtube_red_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "splatoon_red_black_theme").display
# parser.image_renderer(color_theme_key: "splatoon_green_black_theme").display
# parser.image_renderer(color_theme_key: "mario_sky_theme").display
# parser.image_renderer(color_theme_key: "brightness_grey_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "brightness_matrix_theme").display
# parser.image_renderer(color_theme_key: "brightness_matrix_theme", viewpoint: "white").display
# parser.image_renderer(color_theme_key: "brightness_green_theme").display
# parser.image_renderer(color_theme_key: "brightness_orange_theme").display
# parser.image_renderer(color_theme_key: "kimetsu_red_theme", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "kimetsu_blue_theme").display

tp ImageRenderer::ColorThemeInfo.keys

# require 'active_support/core_ext/benchmark'
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1572.6509999949485
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1184.6170000499114
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1225.711999926716
#
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1210.1249999832362
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 882.0249999407679
# Benchmark.ms { parser.image_renderer(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1008.8139999425039
# >> |-------------------------|
# >> | paper_simple_theme      |
# >> | paper_shape_theme       |
# >> | shogi_extend_theme      |
# >> | real_wood_theme3         |
# >> | brightness_grey_theme   |
# >> | brightness_matrix_theme |
# >> | brightness_green_theme  |
# >> | brightness_orange_theme |
# >> | kimetsu_red_theme       |
# >> | kimetsu_blue_theme      |
# >> |-------------------------|
