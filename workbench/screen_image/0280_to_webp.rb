require "../setup"

info = Parser.parse(SFEN1)
bin = info.to_webp
File.write("_output.webp", bin)
`open _output.webp`
