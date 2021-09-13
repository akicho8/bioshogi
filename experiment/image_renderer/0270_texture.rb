require "../example_helper"
parser = Parser.parse(SFEN1)
parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture1.png"}).display
parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture2.png"}).display
parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture3.png"}).display
parser.image_renderer(color_theme_key: "color_theme_is_real_wood1", renderer_override_params: {:fg_file => "#{__dir__}/../../lib/bioshogi/assets/images/board/board_texture4.png"}).display
