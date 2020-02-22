require "../example_helper"

Board.promotable_disable
Board.dimensiton_change([2, 3])

mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
|v香v玉|
|v歩 ・|
| ・ 銀|
+------+
EOT
player = mediator.player_at(:black)
player.move_hands(promoted_only: false, legal_only: true, mate_only: true).collect(&:to_kif).join(" ")   # => "▲２二銀(13) ▲１二銀(13)"
