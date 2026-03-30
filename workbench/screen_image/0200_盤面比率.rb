require "../setup"
require "color"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer(aspect_ratio_w: 1.3, aspect_ratio_h: 1.0)
object.display
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/a06ed70b123e104b35d861a7c8943143.png
