require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
# Board.promotable_disable
Board.dimensiton_change([2, 4]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
後手の持駒：
+------+
|v歩v玉|
| ・ ・|
| 桂 玉|
+------+
先手の持駒：
手数＝1
  EOT
  [
    Diver::NegaAlphaDiver,
    Diver::NegaScoutDiver,
  ].each do |diver_class|
    brain = mediator.current_player.brain(diver_class: diver_class) # Diver::NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 4..4)
    records                     # => [], []
    tp Brain.human_format(records)
  end
end
