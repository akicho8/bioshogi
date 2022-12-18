require "./setup"
require "stackprof"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

container = Container.create
container.pieces_set("▲歩△歩")
container.board.placement_from_shape <<~EOT
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

container.execute("▲17飛", executor_class: PlayerExecutorWithoutMonitor)
container.player_at(:black).evaluator.score  # => 0
container.player_at(:black).evaluator.score2 # => 

container.execute("△23飛", executor_class: PlayerExecutorWithoutMonitor)
container.execute("▲19飛", executor_class: PlayerExecutorWithoutMonitor)
container.execute("△21飛", executor_class: PlayerExecutorWithoutMonitor)
container.execute("▲17飛", executor_class: PlayerExecutorWithoutMonitor)

container.player_at(:black).evaluator.score  # => 
container.player_at(:black).evaluator.score2 # => 
#
# container.player_at(:black).brain.diver_dive(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/evaluator.rb:19:in `score2': undefined local variable or method `player_score_for' for #<Bioshogi::Evaluator:0x00007febd22b68d8> (NameError)
# ~> 	from -:24:in `<main>'
