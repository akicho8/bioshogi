require "./setup"

container = Container::Basic.new
container.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
container.current_player.move_hands(promoted_only: true, king_captured_only: true).any? # => true
container.current_player.mate_advantage?  # => true
container.opponent_player.mate_advantage? # => true
container.position_invalid?               # => true

container = Container::Basic.new
container.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
container.current_player.mate_danger?    # => true
container.current_player.mate_advantage? # => false
container.position_invalid?              # => false
