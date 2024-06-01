require "../setup"
require "color"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer(dimension_w: 6, dimension_h: 6)
object.display
