require "../example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.promotable_disable
Board.dimensiton_change([2, 3])

mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
|v香v玉|
|v歩 ・|
| ・ 金|
+------+
EOT
player = mediator.player_at(:black)
# player.pieces_add("金")
# player.normal_all_hands.collect(&:to_kif).join(" ") # => "▲２二金(13) ▲１二金(13) ▲２三金(13)"
player.move_hands(promoted_preferred: false, king_captured_only: true).collect(&:to_kif).join(" ") # => ""
