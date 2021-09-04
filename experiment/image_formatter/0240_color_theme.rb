require "../example_helper"
require "color"

parser = Parser.parse(<<~EOT)
後手の持駒：飛二 角 銀二 桂四 香四 歩九
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・v竜 竜v馬 馬 ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：飛 角 金四 銀二 桂 香 玉 歩九九

手数----指手---------消費時間--
1 ２六歩(27) (00:00/00:00:00)
EOT

bg_file = "../../lib/bioshogi/assets/images/checker_light.png"
bg_file = Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path.to_s

# ImageFormatter::ColorThemeInfo.each { |e| parser.image_formatter(color_theme_key: e.key).display }
# ImageFormatter::ColorThemeInfo.each { |e| parser.image_formatter(color_theme_key: e.key, override_params: {bg_file: bg_file}).display }

# parser.image_formatter(color_theme_key: "paper_simple_theme", override_params: {bg_file: bg_file}).display
# parser.image_formatter(color_theme_key: "paper_shape_theme", override_params: {bg_file: bg_file}).display
# parser.image_formatter(color_theme_key: "shogi_extend_theme", override_params: {bg_file: bg_file}).display
parser.image_formatter(color_theme_key: "style_editor_theme").display
# parser.image_formatter(color_theme_key: "brightness_grey_theme", override_params: {bg_file: bg_file}).display
# parser.image_formatter(color_theme_key: "brightness_matrix_theme").display
# parser.image_formatter(color_theme_key: "brightness_matrix_theme", viewpoint: "white").display
# parser.image_formatter(color_theme_key: "brightness_green_theme").display
# parser.image_formatter(color_theme_key: "brightness_orange_theme").display
# parser.image_formatter(color_theme_key: "kimetsu_red_theme", override_params: {bg_file: bg_file}).display
# parser.image_formatter(color_theme_key: "kimetsu_blue_theme").display

tp ImageFormatter::ColorThemeInfo.keys

# require 'active_support/core_ext/benchmark'
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1572.6509999949485
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1184.6170000499114
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1225.711999926716
#
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1210.1249999832362
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 882.0249999407679
# Benchmark.ms { parser.image_formatter(color_theme_key: "brightness_matrix_theme").to_blob_binary } # => 1008.8139999425039
# >> |-------------------------|
# >> | paper_simple_theme      |
# >> | paper_shape_theme       |
# >> | shogi_extend_theme      |
# >> | real_wood_theme         |
# >> | brightness_grey_theme   |
# >> | brightness_matrix_theme |
# >> | brightness_green_theme  |
# >> | brightness_orange_theme |
# >> | kimetsu_red_theme       |
# >> | kimetsu_blue_theme      |
# >> |-------------------------|
