require "../../setup"

info = Parser.parse(<<~EOT)
後手の持駒：歩2
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・v金 ・ ・|二
| ・ ・ ・ ・ ・v金 ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ 金|七
| ・ ・ ・ ・ ・ ・ ・ 金 ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
先手の持駒：歩2
手数----指手---------消費時間--
   1 ２九歩打     (00:00/00:00:00)
   2 ３一歩打     (00:00/00:00:00)
   3 １八歩打     (00:00/00:00:00)
   4 ４二歩打     (00:00/00:00:00)
   5 投了
まで4手で後手の勝ち
EOT
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': 打を明示しましたが歩を持っていません (Bioshogi::HoldPieceNotFound)
# ~> 手番: 先手
# ~> 指し手: ２九歩打
# ~> 棋譜:
# ~> 
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# ~> | ・ ・ ・ ・ ・ ・v金 ・ ・|二
# ~> | ・ ・ ・ ・ ・v金 ・ ・ ・|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ 金|七
# ~> | ・ ・ ・ ・ ・ ・ ・ 金 ・|八
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
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
# ~> 	from -:26:in `<main>'
