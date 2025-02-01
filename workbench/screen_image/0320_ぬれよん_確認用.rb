require "../setup"

info = Parser.parse(SFEN1)
object = info.screen_image_renderer({
    :color_theme_key => "is_color_theme_modern", # is_color_theme_modern
    :width           => 1920,
    :height          => 1080,
  })
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/a71f1cada739b55e7cf9f8f342fd6468.png
