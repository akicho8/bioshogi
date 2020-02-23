require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
mediator.current_player.move_hands(promoted_only: true, king_captured_only: true).any? # => true
mediator.current_player.mate_advantage?  # => true
mediator.opponent_player.mate_advantage? # => true
mediator.position_invalid?               # => true

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
mediator.current_player.mate_danger?    # => true
mediator.current_player.mate_advantage? # => false
mediator.position_invalid?              # => false
