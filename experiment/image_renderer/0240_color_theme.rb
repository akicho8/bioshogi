require "../setup"
require "color"

parser = Parser.parse("position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1")
# bg_file = ASSETS_DIR.join("images/checker_grey_light.png")
# bg_file = ASSETS_DIR.join("images/board/original/pakutexture06210140.jpg")
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
#   parser.image_renderer(color_theme_key: "is_color_theme_alpha_asahanada", renderer_override_params: {bg_file: bg_file}).display
# end

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key).display }

# ImageRenderer::ColorThemeInfo.each { |e| parser.image_renderer(color_theme_key: e.key, renderer_override_params: {bg_file: bg_file}).display }

parser.image_renderer(color_theme_key: "is_color_theme_real", renderer_override_params: {piece_image_key: "Portella"}).display

# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_mito").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_skelton").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_heart").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva0").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva1").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva2").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva6").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva8").display
# parser.image_renderer(color_theme_key: "is_color_theme_emoji_pattern_eva13").display

# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva0").display
# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva2").display
# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva8").display
# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva1").display
# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva6").display
# parser.image_renderer(color_theme_key: "is_color_theme_gingham_check_eva13").display

# parser.image_renderer(color_theme_key: "is_color_theme_explosion_yellow").display
# parser.image_renderer(color_theme_key: "is_color_theme_explosion_blue").display
# parser.image_renderer(color_theme_key: "is_color_theme_cloud_green").display
# parser.image_renderer(color_theme_key: "is_color_theme_cloud_pink").display
# parser.image_renderer(color_theme_key: "is_color_theme_cloud_eva0").display
# parser.image_renderer(color_theme_key: "is_color_theme_cloud_eva1").display

# parser.image_renderer(color_theme_key: "is_color_theme_gradiention1").display
# parser.image_renderer(color_theme_key: "is_color_theme_gradiention2").display
# parser.image_renderer(color_theme_key: "is_color_theme_gradiention3").display
# parser.image_renderer(color_theme_key: "is_color_theme_gradiention4").display
#
# parser.image_renderer(color_theme_key: "is_color_theme_radial_gradiention1").display
# parser.image_renderer(color_theme_key: "is_color_theme_radial_gradiention2").display
# parser.image_renderer(color_theme_key: "is_color_theme_radial_gradiention3").display
# parser.image_renderer(color_theme_key: "is_color_theme_radial_gradiention4").display
#
# parser.image_renderer(color_theme_key: "is_color_theme_plasma_blur1").display
# parser.image_renderer(color_theme_key: "is_color_theme_plasma_blur2").display
# parser.image_renderer(color_theme_key: "is_color_theme_plasma_blur3").display
# parser.image_renderer(color_theme_key: "is_color_theme_plasma_blur4").display

# parser.image_renderer(color_theme_key: "is_color_theme_club24").display
# parser.image_renderer(color_theme_key: "is_color_theme_wars_red").display
# parser.image_renderer(color_theme_key: "is_color_theme_wars_blue").display
# parser.image_renderer(color_theme_key: "is_color_theme_piyo").display

# parser.image_renderer(color_theme_key: "is_color_theme_metal1").display

# parser.image_renderer(color_theme_key: "is_color_theme_shogi_extend").display
# parser.image_renderer(color_theme_key: "is_color_theme_paper", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_shape", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_shogi_extend", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_style_editor").display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_asahanada", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_asagi", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_usubudou", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_koiai", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_kuromidori", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_alpha_kurobeni", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_splatoon_stripe_red").display
# parser.image_renderer(color_theme_key: "is_color_theme_splatoon_stripe_green").display
# parser.image_renderer(color_theme_key: "is_color_theme_splatoon_stripe_purple").display
# parser.image_renderer(color_theme_key: "is_color_theme_mario_sky").display
# parser.image_renderer(color_theme_key: "is_color_theme_brightness_grey", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").display
# parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix", viewpoint: "white").display
# parser.image_renderer(color_theme_key: "is_color_theme_brightness_green").display
# parser.image_renderer(color_theme_key: "is_color_theme_brightness_orange").display
# parser.image_renderer(color_theme_key: "is_color_theme_kimetsu_red", renderer_override_params: {bg_file: bg_file}).display
# parser.image_renderer(color_theme_key: "is_color_theme_kimetsu_blue").display

# tp ImageRenderer::ColorThemeInfo.keys

# require 'active_support/core_ext/benchmark'
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 1572.6509999949485
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 1184.6170000499114
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 1225.711999926716
#
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 1210.1249999832362
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 882.0249999407679
# Benchmark.ms { parser.image_renderer(color_theme_key: "is_color_theme_brightness_matrix").to_blob_binary } # => 1008.8139999425039
# >> |-------------------------|
# >> | is_color_theme_paper      |
# >> | is_color_theme_shape       |
# >> | is_color_theme_shogi_extend      |
# >> | is_color_theme_real_wood3         |
# >> | is_color_theme_brightness_grey   |
# >> | is_color_theme_brightness_matrix |
# >> | is_color_theme_brightness_green  |
# >> | is_color_theme_brightness_orange |
# >> | is_color_theme_kimetsu_red       |
# >> | is_color_theme_kimetsu_blue      |
# >> |-------------------------|
