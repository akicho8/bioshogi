require "../setup"

info = Parser.parse(SFEN2)
object = info.screen_image_renderer({
    :color_theme_key => "is_color_theme_real",
    :width           => 1920,
    :height          => 1080,
  })
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/6cb01ddb2f6e17f7ecbec38a11f15326.png
