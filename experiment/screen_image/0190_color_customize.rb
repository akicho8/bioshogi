require "../setup"
require "color"

params = {
  # canvas_bg_color: "#c5e1b7",
  # outer_frame_fill_color: "#91a687",

  :pentagon_color     => { :black => "#000", :white => "#666", },
  :canvas_bg_color      => "#22A",         # 部屋の色
  :outer_frame_fill_color    => "#33A",         # 盤の色
  :piece_font_color       => "#BBA",         # 駒の色
  :stand_piece_color => "#66A",         # 駒の色(持駒)
  :piece_count_font_color => "#55A",         # 駒の色(持駒数)
  :piece_move_cell_fill_color      => "#44A",         # 移動元と移動先のセルの背景色(nilなら描画しない)
  :inner_frame_lattice_color     => "#55A",         # 格子の色
  :inner_frame_stroke_color => "#5858AA",      # 格子の外枠色
  :promoted_font_color    => "#3cA",         # 成駒の色
}

# params = params.inject({}) {|a, (k, v)|
#   if v.kind_of?(String)
#     color = Color::RGB.from_html(v)
#     v2 = color.adjust_hue(50)     # => RGB [#222222], RGB [#333333], RGB [#bbbbbb], RGB [#888888], RGB [#666666], RGB [#444444], RGB [#555555], RGB [#585858], RGB [#60ffff]
#     a.merge(k => v2.html)
#   else
#     a.merge(k => v)
#   end
# }

parser = Parser.parse(<<~EOT)
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

object = parser.screen_image_renderer(params)
object.display
