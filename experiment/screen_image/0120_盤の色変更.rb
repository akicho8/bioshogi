require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer(outer_frame_fill_color: "#aaf")
object.display
