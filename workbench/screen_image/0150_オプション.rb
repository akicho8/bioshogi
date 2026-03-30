require "../setup"

parser = Parser.parse(SFEN1)
object = parser.screen_image_renderer({ width: 100, height: 100, viewpoint: :black })
object.to_blob_binary[0...4]           # => "\x89PNG"
object.display
# >> /Users/ikeda/src/shogi/bioshogi/workbench/tmp/92a94771a23cc5f5d46c3110b1a44dc3.png
