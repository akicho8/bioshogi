require "../setup"
require "color"

parser = Parser.parse(SFEN1)
parser.screen_image_renderer(bg_file: ASSETS_DIR.join("images/matrix.png"), color_theme_key: "orange_lcd_mode").display
parser.screen_image_renderer(color_theme_key: "matrix_mode").display
