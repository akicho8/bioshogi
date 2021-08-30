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

# tp ImageFormatter::ColorThemeInfo.keys

# ImageFormatter::ColorThemeInfo.each { |e| parser.image_formatter(color_theme_key: e.key).display }

# parser.image_formatter(color_theme_key: "first_light_theme").display
# parser.image_formatter(color_theme_key: "pentagon_white_theme").display
parser.image_formatter(color_theme_key: "pentagon_basic_theme").display

# parser.image_formatter(color_theme_key: "dark_theme").display
# parser.image_formatter(color_theme_key: "matrix_theme").display
# parser.image_formatter(color_theme_key: "matrix_theme", viewpoint: "white").display
# parser.image_formatter(color_theme_key: "green_lcd_theme").display
# parser.image_formatter(color_theme_key: "orange_lcd_theme").display
# parser.image_formatter(color_theme_key: "flip_violet_red_theme").display
# parser.image_formatter(color_theme_key: "flip_green_theme").display

# require 'active_support/core_ext/benchmark'
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 1572.6509999949485
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 1184.6170000499114
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 1225.711999926716
#
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 1210.1249999832362
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 882.0249999407679
# Benchmark.ms { parser.image_formatter(color_theme_key: "matrix_theme").to_blob_binary } # => 1008.8139999425039
# >> |-----------------------|
# >> | first_light_theme     |
# >> | pentagon_white_theme  |
# >> | pentagon_basic_theme  |
# >> | dark_theme            |
# >> | matrix_theme          |
# >> | green_lcd_theme       |
# >> | orange_lcd_theme      |
# >> | flip_violet_red_theme |
# >> | flip_green_theme      |
# >> |-----------------------|
