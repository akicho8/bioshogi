require "../example_helper"

parser = Parser.parse(SFEN1)
object = parser.image_renderer
object.display
