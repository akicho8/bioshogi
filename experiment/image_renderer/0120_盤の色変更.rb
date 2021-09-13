require "../example_helper"

parser = Parser.parse(SFEN1)
object = parser.image_renderer(outer_frame_fill_color: "#aaf")
object.display
