require "./example_helper"
require "stackprof"

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

mediator = Mediator.new
mediator.pieces_set("▲歩△歩")
mediator.board.placement_from_shape <<~EOT
+------+
|v飛v香|
| ・ ・|
| ・v歩|
|v香 ・|
|v歩 歩|
| ・ 香|
| 歩 ・|
| ・ ・|
| 香 飛|
+------+
  EOT

mediator.execute("▲17飛", executor_class: PlayerExecutorCpu)
mediator.player_at(:black).evaluator.score  # => 0
mediator.player_at(:black).evaluator.score2 # => 

mediator.execute("△23飛", executor_class: PlayerExecutorCpu)
mediator.execute("▲19飛", executor_class: PlayerExecutorCpu)
mediator.execute("△21飛", executor_class: PlayerExecutorCpu)
mediator.execute("▲17飛", executor_class: PlayerExecutorCpu)
tp mediator.one_place_map

mediator.player_at(:black).evaluator.score  # => 
mediator.player_at(:black).evaluator.score2 # => 
#
# mediator.player_at(:black).brain.diver_dive(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
# ~> /Users/ikeda/src/warabi/lib/warabi/evaluator.rb:19:in `score2': undefined local variable or method `player_score_for' for #<Warabi::Evaluator:0x00007febd22b68d8> (NameError)
# ~> 	from -:24:in `<main>'
