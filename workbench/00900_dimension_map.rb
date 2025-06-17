require "#{__dir__}/setup"
require "stackprof"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

container = Container::Basic.new
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

container.execute("▲17飛", executor_class: PlayerExecutor::WithoutAnalyzer)
container.player_at(:black).evaluator.score  # => 0
container.player_at(:black).evaluator.score2 # =>

container.execute("△23飛", executor_class: PlayerExecutor::WithoutAnalyzer)
container.execute("▲19飛", executor_class: PlayerExecutor::WithoutAnalyzer)
container.execute("△21飛", executor_class: PlayerExecutor::WithoutAnalyzer)
container.execute("▲17飛", executor_class: PlayerExecutor::WithoutAnalyzer)

container.player_at(:black).evaluator.score  # =>
container.player_at(:black).evaluator.score2 # =>
#
# container.player_at(:black).brain.diver_dive(depth_max: 1) # => {:hand=>#<▲２八香(29)>, :score=>0, :depth=>0, :reading_hands=>[#<▲２八香(29)>, #<△９一飛(21)>]}
# ~> -:24:in `<main>': undefined method `score2' for #<Bioshogi::Evaluator::Level1:0x00007fad3b25b670> (NoMethodError)
# ~> Did you mean?  score
