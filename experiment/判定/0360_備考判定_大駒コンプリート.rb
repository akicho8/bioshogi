require "../setup"

info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)   (00:00/00:00:00)
   2 ３四歩(33)   (00:00/00:00:00)
   3 ２二角成(88) (00:00/00:00:00)
   4 ３二飛(82)   (00:00/00:00:00)
   5 ３二馬(22)   (00:00/00:00:00)
   6 ５二玉(51)   (00:00/00:00:00)
   7 投了
まで6手で後手の勝ち
EOT
puts info.to_kif
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/skill_set.rb:38:in `list_of': undefined method `tactic_info' for nil:NilClass (NoMethodError)
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/skill_set.rb:42:in `list_push'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:282:in `block in mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:279:in `each'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:279:in `mediator_run_all'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:46:in `block in mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:44:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:44:in `mediator'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/anything.rb:25:in `mediator_run_once'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/formatter/kif_format_methods.rb:12:in `to_kif'
# ~> 	from -:15:in `<main>'
