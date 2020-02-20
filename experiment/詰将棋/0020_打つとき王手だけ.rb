require "../example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.promotable_disable
Board.dimensiton_change([1, 3])

mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+---+
|v玉|
| ・|
| ・|
+---+
EOT
player = mediator.player_at(:black)
player.pieces_add("金")
player.drop_hands(mate_only: true).collect(&:to_kif).join(" ")   # => "▲１二金打"
