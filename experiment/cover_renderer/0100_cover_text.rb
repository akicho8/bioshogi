require "../setup"

CoverRenderer.new(text: "なんとか　将棋大会\n☗先手 vs ☖後手\n2021-09-12\nabcdefghijklmnopqrstuvwxyz").display
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/cover_renderer/base.rb:40:in `text_normalize': 絵文字と思われる画像化できない文字が含まれています : "なんとか　将棋大会\n☗先手 vs ☖後手\n2021-09-12\nabcdefghijklmnopqrstuvwxyz" (ArgumentError)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/cover_renderer/main_text_methods.rb:32:in `text'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/cover_renderer/main_text_methods.rb:28:in `main_text_render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/cover_renderer/base.rb:28:in `render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/image_renderer/helper.rb:18:in `display'
# ~> 	from -:7:in `<main>'
# >> "なんとか　将棋大会\n☗先手 vs ☖後手\n2021-09-12\nabcdefghijklmnopqrstuvwxyz"
# >> "なんとか　将棋大会\n先手 vs 後手\n2021-09-12\nabcdefghijklmnopqrstuvwxyz"
