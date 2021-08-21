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

parser.image_formatter(bg_file: "#{__dir__}/../../lib/bioshogi/assets/images/matrix.png", color_theme_key: "orange_lcd_mode").display
parser.image_formatter(color_theme_key: "matrix_mode").display
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/image_formatter.rb:191:in `read': unable to open image `/../../lib/bioshogi/assets/images/matrix.png': No such file or directory @ error/blob.c/OpenBlob/2924 (Magick::ImageMagickError)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/image_formatter.rb:191:in `canvas_create'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/image_formatter.rb:152:in `render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/image_formatter.rb:112:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/image_formatter.rb:112:in `render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/binary_format_methods.rb:5:in `image_formatter'
# ~> 	from -:24:in `<main>'
