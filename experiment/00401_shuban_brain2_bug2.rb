require "./example_helper"

# Board.logger = ActiveSupport::Logger.new(STDOUT)
Board.dimensiton_change([2, 4]) do
  mediator = Mediator.new
  mediator.placement_from_bod <<~EOT
後手の持駒：
+------+
|v香v玉|
| ・ ・|
|vと 玉|
| 桂 ・|
+------+
先手の持駒：金
手数＝0
EOT
  [
    NegaAlphaDiver,
    NegaScoutDiver,
  ].each do |diver_class|
    brain = mediator.current_player.brain(diver_class: diver_class, legal_moves_all: false, legal_moves_first_only: false) # NegaAlphaDiver
    records = brain.iterative_deepening(depth_max_range: 3..3)
    records                     # => [], []
    tp Brain.human_format(records)
  end
end
