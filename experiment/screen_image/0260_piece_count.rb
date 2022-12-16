require "../setup"
renderer_override_params = {
  :width  => 1920,
  :height => 1080,
}
info = Parser.parse(SFEN1)
info.screen_image_renderer(color_theme_key: "is_color_theme_shogi_extend", renderer_override_params: renderer_override_params).display
