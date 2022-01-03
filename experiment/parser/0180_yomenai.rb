require "../setup"

info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：
+------+
| ・v玉|
| ・ ・|
| ・ 金|
+------+
下手の持駒：金
下手番
下手：
上手：
手数----指手---------消費時間--
   1 12金
EOT
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': １二に移動できる金がないため打の省略形と考えましたが金を持っていません。手番違いかもしれません。1手目は☖の手番ですが☗が着手しました。手合割は「駒落ち」です。平手で手番のハンデを貰っている場合は☗側が初手を指してください。詰将棋で「上手・下手」の表記を用いている場合は「後手・先手」に直してください (Bioshogi::HoldPieceNotFound2)
# ~> 手番: 上手
# ~> 指し手: 12金
# ~> 棋譜:
# ~> 
# ~> 上手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ 金|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# ~> +---------------------------+
# ~> 下手の持駒：金
# ~> 手数＝0 まで
# ~> 
# ~> 上手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:42:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:23:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:31:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:235:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:225:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:225:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:225:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:49:in `block in mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:47:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:47:in `mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:13:in `mediator_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kif_builder.rb:24:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:460:in `to_kif'
# ~> 	from -:18:in `<main>'
