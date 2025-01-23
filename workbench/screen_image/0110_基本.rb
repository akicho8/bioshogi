require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/932a9d0a714d40fdd74613e18cd8d364.png
