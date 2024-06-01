require "./setup"

# Board.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
# Dimension::PlaceY.promotable_disabled
Dimension.wh_change([2, 4]) do
  container = Container::Basic.new
  container.placement_from_bod <<~EOT
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
    AI::Diver::NegaAlphaDiver,
    AI::Diver::NegaScoutDiver,
  ].each do |diver_class|
    brain = container.current_player.brain(diver_class: diver_class) # AI::Diver::NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 4..4)
    records                     # => [], []
    tp AI::Brain.human_format(records)
  end
end
