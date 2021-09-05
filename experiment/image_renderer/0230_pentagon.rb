require "../example_helper"

parser = Parser.parse(<<~EOT, turn_limit: 10)
後手の持駒：玉99 飛11 角99 金9 銀1 桂四 香四 歩九
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・v竜 竜 ・ ・ ・v馬 馬 ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| と 歩 と 歩 と 歩 と 歩 と|七
| ・ 角 全 ・ ・ ・ ・ 飛 ・|八
| 香 圭 銀 金 玉 金 銀 桂 杏|九
+---------------------------+
先手の持駒：飛99 角11 金四 銀二 桂 香 玉 歩九九
手数----指手---------消費時間--
1 ２六歩(27) (00:00/00:00:00)
EOT

bin = parser.to_png(color_theme_key: "paper_simple_theme")
Pathname("_output1.png").write(bin)
`open _output1.png`

# bin = parser.to_png(color_theme_key: "paper_shape_theme")
# Pathname("_output1.png").write(bin)
# `open _output1.png`

# bin = parser.to_png(color_theme_key: "shogi_extend_theme")
# Pathname("_output1.png").write(bin)
# `open _output1.png`
