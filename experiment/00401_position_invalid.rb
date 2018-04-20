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
mediator.current_player.move_hands(promoted_preferred: true, king_captured_only: true).any? # => true
mediator.current_player.suguni_ou_toreru?  # => true
mediator.opponent_player.suguni_ou_toreru? # => true
mediator.position_invalid?      # => true

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
mediator.current_player.oute_kakerareteru? # => true
mediator.current_player.suguni_ou_toreru?  # => false
mediator.position_invalid?      # => false
