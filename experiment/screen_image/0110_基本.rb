require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer
object.display
