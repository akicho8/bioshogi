require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
# Board.promotable_disable
Board.dimensiton_change([3, 3]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
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
    NegaAlphaDiver,
    NegaScoutDiver,
  ].each do |diver_class|
    brain = mediator.current_player.brain(diver_class: diver_class) # NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 0..0)
    p records
    tp Brain.human_format(records)
  end
end
# >> []
# >> []
