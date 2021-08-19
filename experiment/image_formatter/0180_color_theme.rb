require "../example_helper"
require "color"

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

ColorThemeInfo.each do |e|
  p e
  parser.image_formatter(color_theme_key: e.key).display
end

# parser.image_formatter(color_theme_key: "light_mode").display
# parser.image_formatter(color_theme_key: "dark_mode").display
# parser.image_formatter(color_theme_key: "matrix_mode").display
# parser.image_formatter(color_theme_key: "orange_lcd_mode").display

tp ColorThemeInfo.fetch(:matrix_mode).to_params
# >> <light_mode>
# >> <dark_mode>
# >> <matrix_mode>
# >> <orange_lcd_mode>
# >> |------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |           hexagon_fill | true                                                                                                                                                    |
# >> |          hexagon_color | {:black=>"#003d00", :white=>"#00f500"}                                                                                                                  |
# >> |           canvas_color | #001000                                                                                                                                                 |
# >> |         frame_bg_color | #002100                                                                                                                                                 |
# >> |           moving_color | #003d00                                                                                                                                                 |
# >> |          lattice_color | #007a00                                                                                                                                                 |
# >> |            frame_color | #008f00                                                                                                                                                 |
# >> |      stand_piece_color | #008f00                                                                                                                                                 |
# >> |      piece_count_color | #006600                                                                                                                                                 |
# >> |            piece_color | #00cc00                                                                                                                                                 |
# >> |     last_soldier_color | #5cff5c                                                                                                                                                 |
# >> |         promoted_color | #47ff47                                                                                                                                                 |
# >> | normal_piece_color_map | {:king=>"#33ff33", :rook=>"#33ff33", :bishop=>"#33ff33", :gold=>"#00ab00", :silver=>"#00a900", :knight=>"#00a700", :lance=>"#00a500", :pawn=>"#00a300"} |
# >> |------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------|
