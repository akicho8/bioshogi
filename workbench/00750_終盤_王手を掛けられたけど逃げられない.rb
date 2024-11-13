require "./setup"

# Board.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
# Dimension::Row.promotable_disabled
Dimension.change([3, 3]) do
  container = Container::Basic.new
  container.placement_from_bod <<~EOT
後手の持駒：
+---------+
|v玉 ・ ・|
| ・ 歩 歩|
|v飛 ・ 玉|
+---------+
先手の持駒：
手数＝0
  EOT
  [
    AI::Diver::NegaAlphaDiver,
    AI::Diver::NegaScoutDiver,
  ].each do |diver_class|
    brain = container.current_player.brain(diver_class: diver_class) # AI::Diver::NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 0..0)
    p records
    tp AI::Brain.human_format(records)
  end
end
# >> []
# >> []
