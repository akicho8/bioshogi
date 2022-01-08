require "../setup"
info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：
+------+
| 飛v玉|
+------+
下手の持駒：金
下手番
下手：
上手：
手数----指手---------消費時間--
   1 11飛
EOT
p info
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:131:in `raise_error': 駒の上に打とうとしています (Bioshogi::PieceAlredyExist)
# ~> 手番: 上手
# ~> 指し手: 11飛
# ~> 棋譜:
# ~> 
# ~> 上手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・ ・ ・ ・ ・ ・ ・ 飛v玉|一
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
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
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:283:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:273:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:273:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:273:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:49:in `block in mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:47:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:47:in `mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:13:in `mediator_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/kif_builder.rb:24:in `to_s'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/export_methods.rb:508:in `to_kif'
# ~> 	from -:16:in `<main>'
# >> * @board_source
# >> +------+
# >> | 飛v玉|
# >> +------+
# >>  
# >> * attributes
# >> |-------------------+--------|
# >> | force_preset_info | 平手   |
# >> |      balance_info | 通常戦 |
# >> |    force_location | ▲     |
# >> |    force_handicap | true   |
# >> |-------------------+--------|
# >>  
# >> * header attributes
# >> |------------+--------|
# >> |     手合割 | その他 |
# >> | 下手の持駒 | 金     |
# >> |------------+--------|
# >>  
# >> * header methods (read)
# >> |-------------------+------|
# >> | handicap_validity | true |
# >> |    force_location |      |
# >> |-------------------+------|
# >>  
# >> * @board_source
# >> +------+
# >> | 飛v玉|
# >> +------+
# >>  
# >> * move_infos
# >> |-------------+-------+------------+--------------|
# >> | turn_number | input | clock_part | used_seconds |
# >> |-------------+-------+------------+--------------|
# >> |           1 | 11飛  |            |              |
# >> |-------------+-------+------------+--------------|
# >>  
# >> * @last_status_params
