require "./example_helper"

parser = Parser.parse("▲68銀")
canvas = parser.to_img.canvas
canvas.format = "png"
canvas.mime_type                # => "image/png"
canvas.to_blob[0..8]            # => "\x89PNG\r\n\x1A\n\x00"
