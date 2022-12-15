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
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:42:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:21:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/xcontainer_executor.rb:30:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/xcontainer_executor.rb:29:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/xcontainer_executor.rb:29:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:26:in `block in perform'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `perform'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:116:in `xcontainer_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:47:in `block in xcontainer'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:45:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:45:in `xcontainer'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:11:in `xcontainer_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kakinoki_builder.rb:25:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:201:in `to_kif'
# ~> 	from -:22:in `<main>'
# >> * mi.board_source
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金 ・v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>  
# >> * attributes
# >> |-------------------+--|
# >> | force_preset_info |  |
# >> |    force_location |  |
# >> |    force_handicap |  |
# >> |-------------------+--|
# >>  
# >> * mi.header
# >> |--------+--------|
# >> | 手合割 | その他 |
# >> |--------+--------|
# >>  
# >> * @parser.mi.board_source
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金 ・v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>  
# >> * mi.move_infos
# >> |----------|
# >> | input    |
# >> |----------|
# >> | △８四歩 |
# >> |----------|
# >>  
# >> * @parser.mi.last_action_params
