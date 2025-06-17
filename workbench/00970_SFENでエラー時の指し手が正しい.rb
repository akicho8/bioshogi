require "#{__dir__}/setup"

sfen = "position startpos moves 7i6h 8c8d 5g5f 8d8e 6h5g 3c3d 6i7h 7a7b 2g2f 7b8c 5g6f 8c7d 2f2e 4a3b 2e2d 2c2d 2h2d P*2c 2d3d 2b4d 2e2d 2c2d 8h7i 2b4d 2h2d 3a3b 7i5g P*8h 7h8h 2a3c 2d2h P*8f 8g8f 8e8f P*8d P*2f 4i5h 8f9e 8h7h 9e8d P*8h 5a6b 4g4f 7c7d 5g6f 4d6f 6g6f B*4d 5f5e 8d7e B*2b 8a7c 6e7d 6a7b 2b1a+ 8b8d 7d7c 7b7c 1a1b 7e6f L*6i S*5g 6i6f 5g6f P*6g 6f7e 3i3h L*8f N*8g 8f8g+ 8h8g P*8h 7h8h P*8f"
info = Parser.parse(sfen)
info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/error_handler.rb:12:in `call': ２五に何もありません (Bioshogi::PieceNotFoundOnBoard)
# ~> 手番: 先手
# ~> 指し手: "2e2d"
# ~> 棋譜: ６八銀(79) ８四歩(83) ５六歩(57) ８五歩(84) ５七銀(68) ３四歩(33) ７八金(69) ７二銀(71) ２六歩(27) ８三銀(72) ６六銀(57) ７四銀(83) ２五歩(26) ３二金(41) ２四歩(25) ２四歩(23) ２四飛(28) ２三歩打 ３四飛(24) ４四角(22)
# ~>
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> |v香v桂 ・v金v玉 ・v銀v桂v香|一
# ~> | ・v飛 ・ ・ ・ ・v金 ・ ・|二
# ~> |v歩 ・v歩v歩v歩v歩 ・v歩v歩|三
# ~> | ・ ・v銀 ・ ・v角 飛 ・ ・|四
# ~> | ・v歩 ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ 銀 歩 ・ ・ ・ ・|六
# ~> | 歩 歩 歩 歩 ・ 歩 歩 ・ 歩|七
# ~> | ・ 角 金 ・ ・ ・ ・ ・ ・|八
# ~> | 香 桂 ・ ・ 玉 金 銀 桂 香|九
# ~> +---------------------------+
# ~> 先手の持駒：歩二
# ~> 手数＝20 △４四角(22) まで
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:38:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor/base.rb:43:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:24:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:31:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:30:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/container/execute_methods.rb:30:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:26:in `block in call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/runner.rb:16:in `call'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:165:in `container_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:105:in `block in container'
# ~> 	from <internal:kernel>:90:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:103:in `container'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:69:in `container_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_ki2_shared.rb:26:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/core.rb:31:in `to_kif'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/parser_methods.rb:7:in `to_kif'
# ~> 	from -:5:in `<main>'
