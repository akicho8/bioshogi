require "./example_helper"

info = Parser.parse(<<~EOT)
開始日時：2003/08/25
棋戦：ＮＨＫ杯
戦型：中飛車
備考：▲ゴキゲン中飛車位取り型
先手：畠山成幸
後手：郷田真隆

場所：ＮＨＫ放送センター
持ち時間：15分＋30秒＋10回
*放映日：2003/09/07
*棋戦詳細：第53回ＮＨＫ杯戦2回戦第05局
*「畠山成幸七段」vs「郷田真隆九段」
▲７六歩    △８四歩    ▲５六歩    △３四歩    ▲５五歩    △６二銀
まで138手で後手の勝ち
EOT

tp info.header
tp info.raw_header
# ~> /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:139:in `block in header_normalize': undefined local variable or method `e' for #<Bushido::Parser::Ki2Parser:0x007ffda1ac9558> (NameError)
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:130:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:130:in `header_normalize'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/ki2_parser.rb:15:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:20:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:20:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser.rb:13:in `parse'
# ~> 	from -:3:in `<main>'
