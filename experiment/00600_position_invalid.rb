require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
xcontainer.current_player.move_hands(promoted_only: true, king_captured_only: true).any? # => true
xcontainer.current_player.mate_advantage?  # => true
xcontainer.opponent_player.mate_advantage? # => true
xcontainer.position_invalid?               # => true

xcontainer = Xcontainer.new
xcontainer.placement_from_bod <<~EOT
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
先手の持駒：
手数＝0
EOT
xcontainer.current_player.mate_danger?    # => true
xcontainer.current_player.mate_advantage? # => false
xcontainer.position_invalid?              # => false
