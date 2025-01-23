require "../setup"

info = Parser.parse(SFEN2)
object = info.screen_image_renderer({
    :color_theme_key => "is_color_theme_real",
    :width           => 1920,
    :height          => 1080,
  })
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/5750839fd1e2b674b60cf6e5ca7e1746.png
