require "../setup"
require "color"

parser = Parser.parse(SFEN1)
parser.screen_image_renderer(bg_file: ASSETS_DIR.join("images/matrix.png"), color_theme_key: "orange_lcd_mode").display
parser.screen_image_renderer(color_theme_key: "matrix_mode").display
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/screen_image_renderer.rb:191:in `read': unable to open image `/ASSETS_DIR.join("images/matrix.png': No such file or directory @ error/blob.c/OpenBlob/2924 (Magick::ImageMagickError)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/screen_image_renderer.rb:191:in `canvas_create'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/screen_image_renderer.rb:152:in `render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/screen_image_renderer.rb:112:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/screen_image_renderer.rb:112:in `render'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/binary_format_methods.rb:5:in `screen_image_renderer'
# ~> 	from -:24:in `<main>'
