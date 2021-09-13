require "../example_helper"

parser = Parser.parse(SFEN1)
bin = parser.to_png(color_theme_key: "paper_simple_theme")
Pathname("_output1.png").write(bin)
`open _output1.png`

# bin = parser.to_png(color_theme_key: "paper_shape_theme")
# Pathname("_output1.png").write(bin)
# `open _output1.png`

# bin = parser.to_png(color_theme_key: "shogi_extend_theme")
# Pathname("_output1.png").write(bin)
# `open _output1.png`
