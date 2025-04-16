require "../setup"
info = Parser.parse(<<~EOT)
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：なし
手数----指手---------消費時間--
  2 ５四歩(53)
  3 ３六歩(37)
  4 投了
まで5手で先手の勝ち
EOT
p info
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': 【反則】相手の駒を動かそうとしています。手番違いかもしれません。1手目は☗の手番ですが☖が着手しました (Bioshogi::ReversePlayerPieceMoveError)
# ~> 手番: 先手
# ~> 指し手: ５四歩(53)
# ~> 棋譜:
# ~>
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂v銀v金v玉v金v銀v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# ~> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# ~> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
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
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:286:in `block in container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:276:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:276:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:276:in `container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:49:in `block in container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:47:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:47:in `container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:13:in `formatter.container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kif_builder.rb:24:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:511:in `to_kif'
# ~> 	from -:24:in `<main>'
# >> * @pi.board_source
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>
# >> * attributes
# >> |-------------------+--------|
# >> | pi.force_preset_info | 平手   |
# >> |      balance_info | 通常戦 |
# >> |    pi.force_location |        |
# >> |    pi.force_handicap |        |
# >> |-------------------+--------|
# >>
# >> * pi.header attributes
# >> |------------+--|
# >> | 後手の持駒 |  |
# >> | 先手の持駒 |  |
# >> |------------+--|
# >>
# >> * pi.header methods (read)
# >> |-------------------+--|
# >> | handicap_validity |  |
# >> |    pi.force_location |  |
# >> |-------------------+--|
# >>
# >> * @pi.board_source
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >>
# >> * pi.move_infos
# >> |-------------+------------+------------+--------------|
# >> | turn_number | input      | clock_part | used_seconds |
# >> |-------------+------------+------------+--------------|
# >> |           2 | ５四歩(53) |            |              |
# >> |           3 | ３六歩(37) |            |              |
# >> |-------------+------------+------------+--------------|
# >>
# >> * @pi.last_action_params
# >> |-----------------+------|
# >> |     turn_number | 4    |
# >> | last_action_key | 投了 |
# >> |    used_seconds |      |
# >> |-----------------+------|
