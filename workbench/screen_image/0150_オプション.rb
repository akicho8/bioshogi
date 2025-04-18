require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer({ width: 100, height: 100, viewpoint: :black })
object.to_blob_binary[0...4]           # => "\x89PNG"
object.display
# >> /Users/ikeda/src/bioshogi/workbench/tmp/ce3f3a8851ad2250df6acd95d4a685d8.png
