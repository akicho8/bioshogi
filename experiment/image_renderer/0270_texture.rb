require "../setup"
parser = Parser.parse(SFEN1)
parser.image_renderer(color_theme_key: "is_color_theme_real", renderer_override_params: {:fg_file => ASSETS_DIR.join("images/board/board_texture1.png")}).display
