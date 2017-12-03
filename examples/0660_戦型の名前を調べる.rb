require "./example_helper"

# ▲７六歩 △８四歩 ▲２六歩 △３二金 ▲７八金 △８五歩 ▲７七角 △３四歩 ▲８八銀 △７七角成

info = Parser.parse(<<~EOT)
▲７六歩 △６二玉
EOT

puts info.mediator
tp info.mediator.players.first.attack_infos
tp info.mediator.players.last.attack_infos
puts info.to_ki2
# ~> /Users/ikeda/src/bushido/lib/bushido/position.rb:80:in `parse': "h" が ["一", "二", "三", "四", "五", "六", "七", "八", "九"] の中にありません (Bushido::PositionSyntaxError)
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/position.rb:199:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/point.rb:52:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/point.rb:31:in `[]'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:152:in `block (2 levels) in cell_walker'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:150:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:150:in `with_index'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:150:in `block in cell_walker'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:148:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:148:in `with_index'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:148:in `cell_walker'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:165:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:36:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/board_parser.rb:36:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/shape_info.rb:1967:in `board_parser'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/teaiwari_info.rb:34:in `board_parser'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:62:in `block (3 levels) in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:22:in `catch'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:22:in `block (2 levels) in execute'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/memory_record-0.0.7/lib/memory_record/memory_record.rb:145:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/gems/2.4.0/gems/memory_record-0.0.7/lib/memory_record/memory_record.rb:145:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:20:in `block in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:17:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/skill_monitor.rb:17:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/player.rb:146:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:246:in `block in execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:231:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/mediator.rb:231:in `execute'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:374:in `block (2 levels) in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:373:in `each'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:373:in `block in mediator'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:348:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:348:in `mediator'
# ~> 	from -:9:in `<main>'
