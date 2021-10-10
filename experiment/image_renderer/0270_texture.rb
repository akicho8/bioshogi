require "../setup"
parser = Parser.parse(SFEN1)
parser.image_renderer(color_theme_key: "is_color_theme_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture1.png"}).display
parser.image_renderer(color_theme_key: "is_color_theme_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture2.png"}).display
parser.image_renderer(color_theme_key: "is_color_theme_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture3.png"}).display
parser.image_renderer(color_theme_key: "is_color_theme_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture4.png"}).display
