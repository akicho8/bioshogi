require "../setup"
parser = Parser.parse(Bioshogi::SFEN1)
params = {
  :color_theme_key => "is_color_theme_real",
  :renderer_override_params => {
    :width  => 1920,
    :height => 1080,
  },
}
parser.image_renderer(params).display
