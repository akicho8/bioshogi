require "../setup"

Parser.parse("V2,P1 *,+0093KA,T1").to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:127:in `raise_error': 先手は角を９三に打とうとしましたが角を持っていません (Bioshogi::HoldPieceNotFound)
# ~> 手番: 先手
# ~> 指し手: +0093KA
# ~> 棋譜:
# ~> 
# ~> 後手の持駒：なし
# ~>   ９ ８ ７ ６ ５ ４ ３ ２ １
# ~> +---------------------------+
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# ~> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# ~> +---------------------------+
# ~> 先手の持駒：なし
# ~> 手数＝0 まで
# ~> 
# ~> 先手番
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:37:in `perform_validations'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:42:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:23:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:31:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:234:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:224:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:224:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:224:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:46:in `block in mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:44:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:44:in `mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:25:in `mediator_run'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_format_methods.rb:12:in `to_kif'
# ~> 	from -:3:in `<main>'
