require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.promotable_disable
Board.dimensiton_change([1, 3])

xcontainer = Xcontainer.new
xcontainer.board.placement_from_shape <<~EOT
+---+
|v玉|
| ・|
| ・|
+---+
EOT
player = xcontainer.player_at(:black)
player.pieces_add("金")
player.drop_hands(mate_only: true).collect(&:to_kif).join(" ")   # => "▲１二金打"
