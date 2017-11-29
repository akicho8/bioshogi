require "./example_helper"

info = Parser.parse(<<~EOT)
開始日時：2007/07/17 10:00
終了日時：2007/07/17 10:00
棋戦：順位戦
戦型：その他の戦型
消費時間：▲000△000
先手：東　和男
後手：有吉道夫

場所：大阪「関西将棋会館」
持ち時間：6時間
*棋戦詳細：第66期順位戦C級2組02回戦
*「東　和男七段」vs「有吉道夫九段」
*初手は△３四歩。後手番有吉九段が初手を着手したため、東七段の反則勝ち。
△３四歩(33)
まで1手で後手の反則負け
EOT

puts info.to_kif
# ~> /Users/ikeda/src/bushido/lib/bushido/player.rb:104:in `move_to': 【反則】相手の駒を動かそうとしています。▲の手番で３三にある△の歩を３四に動かそうとしています (Bushido::AitenoKomaUgokashitaError)
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v銀v金v玉v金v銀v桂v香|一
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
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/runner.rb:179:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:140:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:220:in `block in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:219:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:219:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:339:in `block (2 levels) in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:338:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:338:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:312:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:312:in `mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:240:in `to_kif'
# ~> 	from -:21:in `<main>'
