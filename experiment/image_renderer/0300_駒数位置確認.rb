require "../setup"

info = Parser.parse(SFEN1)
object = info.image_renderer({
    :color_theme_key => "is_color_theme_real_wood1",
    :width           => 1920,
    :height          => 1080,
  })
object.display
