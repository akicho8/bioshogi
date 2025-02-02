require "../setup"

info = Parser.parse(SFEN1)
object = info.screen_image_renderer({
    :color_theme_key => "is_color_theme_modern", # is_color_theme_modern
    :width           => 1920,
    :height          => 1080,
  })
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/4c3fa3a6368a3e0ca0cb33e0fd680afc.png
