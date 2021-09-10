require "../example_helper"

info = Parser.parse("")
bin = info.to_webp
File.write("_output.webp", bin)
`open _output.webp`
