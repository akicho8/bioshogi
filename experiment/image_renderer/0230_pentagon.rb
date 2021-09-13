require "../example_helper"

parser = Parser.parse(SFEN1)
bin = parser.to_png(color_theme_key: "color_theme_is_paper_simple")
Pathname("_output1.png").write(bin)
`open _output1.png`

# bin = parser.to_png(color_theme_key: "color_theme_is_paper_shape")
# Pathname("_output1.png").write(bin)
# `open _output1.png`

# bin = parser.to_png(color_theme_key: "color_theme_is_shogi_extend")
# Pathname("_output1.png").write(bin)
# `open _output1.png`
