require "../setup"

info = Parser.parse(SFEN1)
object = info.screen_image_renderer({
    :color_theme_key => "is_color_theme_real",
    :width           => 1920,
    :height          => 1080,
  })
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/c84a502847dde7aafe5f9d095a7ada12.png
