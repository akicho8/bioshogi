require "../example_helper"

info = Parser.parse(<<~EOT)
後手の持駒：飛二 角 銀二 桂四 香四 歩九
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・v竜 竜v馬 馬 ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：飛 角 金四 銀二 桂 香 玉 歩九九

手数----指手---------消費時間--
1 ２六歩(27) (00:00/00:00:00)
EOT

# ImageRenderer::FontThemeInfo.each do |e|
#   info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: e.key).display
#   info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: e.key, soldier_font_bold: true).display
# end

info.image_renderer(color_theme_key: "real_wood_theme", font_theme_key: "mplus_rounded1c_sans", soldier_font_bold: true).display

# info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: "ricty_sans").display
# info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: "ricty_sans", soldier_font_bold: true).display
# info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: "noto_seif").display
# info.image_renderer(color_theme_key: "paper_simple_theme", font_theme_key: "noto_seif", soldier_font_bold: true).display

