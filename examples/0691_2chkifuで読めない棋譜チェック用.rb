require "./example_helper"

info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金 ・v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし

△８四歩
EOT

puts info.to_kif
# ~> /Users/ikeda/src/bushido/lib/bushido/runner.rb:249:in `find_origin_point': ▲番で "８四" の地点に移動できる "歩" (または"と") がありません。入力した "８四歩" がまちがっている可能性があります (Bushido::MovableSoldierNotFound)
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v銀v金v玉v金 ・v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# ~> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# ~> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# ~> | 香 桂 銀 金 玉 金 銀 桂 香|九
# ~> +---------------------------+
# ~> 先手の持駒：なし
# ~> 手数＝0 まで
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/runner.rb:154:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:134:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:213:in `block in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:212:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:212:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:330:in `block (2 levels) in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:329:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:329:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:308:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:308:in `mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:236:in `to_kif'
# ~> 	from -:23:in `<main>'
