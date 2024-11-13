require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Dimension::Row.promotable_disabled
Dimension.change([1, 3])

container = Container::Basic.new
container.board.placement_from_shape <<~EOT
+---+
|v玉|
| ・|
| ・|
+---+
EOT
player = container.player_at(:black)
player.pieces_add("金")
player.drop_hands(mate_only: true).collect(&:to_kif).join(" ")   # => "▲１二金打"
