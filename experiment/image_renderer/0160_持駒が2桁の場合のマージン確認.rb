require "../setup"

parser = Parser.parse(SFEN1)
object = parser.image_renderer
object.display
