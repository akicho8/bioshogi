require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer
object.display
# >> /Users/ikeda/src/bioshogi/experiment/tmp/308fdb14cadd8389d75d0fc7fdd3c8cf.png
