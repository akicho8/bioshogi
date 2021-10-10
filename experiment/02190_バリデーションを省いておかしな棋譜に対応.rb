require "./setup"

mediator_options = {
  skill_monitor_enable: false,
  skill_monitor_technique_enable: false,
  candidate_enable: false,
  validate_enable: false,
}

body = "51玉(59)"
body = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 5i5e"
body = "position startpos moves P*5e"
info = Parser.parse(body, mediator_options)
puts info.to_kif
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/delegate.rb:85:in `call': 持駒から歩を取り出そうとしましたが歩を持っていません : {} (Bioshogi::HoldPieceNotFound)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/delegate.rb:85:in `method_missing'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/piece_box.rb:23:in `pick_out'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/soldier.rb:347:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player_executor_base.rb:54:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/player.rb:23:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:31:in `block in execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/mediator_executor.rb:30:in `execute'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:238:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:228:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:228:in `with_index'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:228:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:50:in `block in mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:48:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:48:in `mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:29:in `mediator_run'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_format_methods.rb:12:in `to_kif'
# ~> 	from -:14:in `<main>'
