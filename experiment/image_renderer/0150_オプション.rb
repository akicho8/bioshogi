require "../example_helper"

parser = Parser.parse(SFEN1)
object = parser.image_renderer({width: 100, height: 100, viewpoint: :black})
object.to_blob[0...4]           # => "\x89PNG"
object.display
