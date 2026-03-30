require "../setup"
require "color"

parser = Parser.parse(SFEN1)
parser.screen_image_renderer(bg_file: ASSETS_DIR.join("images/matrix.png"), color_theme_key: "orange_lcd_mode").display
parser.screen_image_renderer(color_theme_key: "matrix_mode").display
# ~> /Users/ikeda/src/shogi/bioshogi/lib/bioshogi/screen_image/core_methods.rb:177:in 'Magick::Image.read': unable to open image '/Users/ikeda/src/shogi/bioshogi/lib/bioshogi/assets/images/matrix.png': No such file or directory @ error/blob.c/OpenBlob/3596 (Magick::ImageMagickError)
# ~> 	from /Users/ikeda/src/shogi/bioshogi/lib/bioshogi/screen_image/core_methods.rb:177:in 'Bioshogi::ScreenImage::CoreMethods#canvas_layer_create'
# ~> 	from /Users/ikeda/src/shogi/bioshogi/lib/bioshogi/screen_image/core_methods.rb:130:in 'block in Bioshogi::ScreenImage::CoreMethods#render'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2/lib/active_support/tagged_logging.rb:143:in 'block in ActiveSupport::TaggedLogging#tagged'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2/lib/active_support/tagged_logging.rb:38:in 'ActiveSupport::TaggedLogging::Formatter#tagged'
# ~> 	from /opt/rbenv/versions/3.4.2/lib/ruby/gems/3.4.0/gems/activesupport-8.0.2/lib/active_support/tagged_logging.rb:143:in 'ActiveSupport::TaggedLogging#tagged'
# ~> 	from /Users/ikeda/src/shogi/bioshogi/lib/bioshogi/screen_image/core_methods.rb:123:in 'Bioshogi::ScreenImage::CoreMethods#render'
# ~> 	from /Users/ikeda/src/shogi/bioshogi/lib/bioshogi/screen_image/helper.rb:18:in 'Bioshogi::ScreenImage::Helper#display'
# ~> 	from -:5:in '<main>'
