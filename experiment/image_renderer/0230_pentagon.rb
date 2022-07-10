require "../setup"

parser = Parser.parse(SFEN1)
bin = parser.to_png(color_theme_key: "is_color_theme_paper")
Pathname("_output1.png").write(bin)
`open _output1.png`

# bin = parser.to_png(color_theme_key: "is_color_theme_shape")
# Pathname("_output1.png").write(bin)
# `open _output1.png`

# bin = parser.to_png(color_theme_key: "is_color_theme_shogi_extend")
# Pathname("_output1.png").write(bin)
# `open _output1.png`
