require "../setup"
renderer_override_params = {
  :outer_frame_stroke_width => 2,
  :outer_frame_stroke_color => "hsla(120,100%,50%,1.0)",
}
info = Parser.parse(SFEN1)
info.screen_image_renderer(color_theme_key: "is_color_theme_shogi_extend", renderer_override_params: renderer_override_params).display
