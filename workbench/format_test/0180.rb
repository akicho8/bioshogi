require "../setup"
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
p info
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': 【反則】先手の手番で後手が着手しました (Bioshogi::DifferentTurnCommonError)
# ~> 手番: 先手
# ~> 指し手: △８四歩
# ~> 棋譜:
# ~>
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
# ~>
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:42:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:23:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container_executor.rb:31:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container_executor.rb:30:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container_executor.rb:30:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:283:in `block in container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:273:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:273:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:273:in `container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:49:in `block in container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:47:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:47:in `container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:13:in `formatter.container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kif_builder.rb:24:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:508:in `to_kif'
# ~> 	from -:22:in `<main>'























































