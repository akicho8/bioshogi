require "../example_helper"
require "color"

parser = Parser.parse("position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1")
bg_file = "../../lib/bioshogi/assets/images/checker_light.png"
bg_file = "../../lib/bioshogi/assets/images/board/original/pakutexture06210140.jpg"
bg_file = Pathname("~/Pictures/ぱくたそ/Redsugar20207061_TP_V.jpg").expand_path.to_s
bg_file = Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path.to_s
bg_file = nil

# %w(
# 03.-Snowy-Mint_1.jpg
# 65.-Prim_1.jpg
# 70.-Honeydew.jpg
# 96.-Lake.jpg
# ).each do |e|
#   bg_file = Pathname("~/Downloads/#{e}").expand_path.to_s
#   parser.image_renderer(color_theme_key: "color_theme_is_style_editor_asahanada", renderer_override_params: {bg_file: bg_file}).display
# end

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key).display }

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key, renderer_override_params: {bg_file: bg_file}).display }

# parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {fg_file: bg_file, bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_real_wood2").display
# parser.image_renderer(color_theme_key: "color_theme_is_real_wood3").display

# parser.image_renderer(color_theme_key: "color_theme_is_gradiention1").display
# parser.image_renderer(color_theme_key: "color_theme_is_gradiention2").display
# parser.image_renderer(color_theme_key: "color_theme_is_gradiention3").display
# parser.image_renderer(color_theme_key: "color_theme_is_gradiention4").display

parser.image_renderer(color_theme_key: "color_theme_is_radial_gradiention1").display
parser.image_renderer(color_theme_key: "color_theme_is_radial_gradiention2").display
parser.image_renderer(color_theme_key: "color_theme_is_radial_gradiention3").display
parser.image_renderer(color_theme_key: "color_theme_is_radial_gradiention4").display

# parser.image_renderer(color_theme_key: "color_theme_is_metal1").display

# parser.image_renderer(color_theme_key: "color_theme_is_paper_simple", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_paper_shape", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_shogi_extend", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor").display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor_asahanada", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor_usubudou", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor_koiai", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor_kuromidori", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_style_editor_kurobeni", renderer_override_params: {bg_file: bg_file}).display

# parser.image_renderer(color_theme_key: "color_theme_is_splatoon_red_black").display
# parser.image_renderer(color_theme_key: "color_theme_is_splatoon_green_black").display
# parser.image_renderer(color_theme_key: "color_theme_is_mario_sky").display
# parser.image_renderer(color_theme_key: "color_theme_is_brightness_grey", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").display
# parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix", viewpoint: "white").display
# parser.image_renderer(color_theme_key: "color_theme_is_brightness_green").display
# parser.image_renderer(color_theme_key: "color_theme_is_brightness_orange").display
# parser.image_renderer(color_theme_key: "color_theme_is_kimetsu_red", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "color_theme_is_kimetsu_blue").display

tp ImageRenderer::ColorThemeInfo.keys

# require 'active_support/core_ext/benchmark'
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 1572.6509999949485
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 1184.6170000499114
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 1225.711999926716
#
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 1210.1249999832362
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 882.0249999407679
# Benchmark.ms { parser.image_renderer(color_theme_key: "color_theme_is_brightness_matrix").to_blob_binary } # => 1008.8139999425039
# >> |-------------------------|
# >> | color_theme_is_paper_simple      |
# >> | color_theme_is_paper_shape       |
# >> | color_theme_is_shogi_extend      |
# >> | color_theme_is_real_wood3         |
# >> | color_theme_is_brightness_grey   |
# >> | color_theme_is_brightness_matrix |
# >> | color_theme_is_brightness_green  |
# >> | color_theme_is_brightness_orange |
# >> | color_theme_is_kimetsu_red       |
# >> | color_theme_is_kimetsu_blue      |
# >> |-------------------------|
