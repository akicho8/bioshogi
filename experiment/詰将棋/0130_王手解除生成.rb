require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.dimensiton_change([2, 3])

container = Container.create
container.board.placement_from_shape <<~EOT
+------+
| ・v玉|
| ・ 銀|
| ・ 歩|
+------+
EOT
tp container.player_at(:white).create_all_hands(legal_only: true)
# >> |--------------|
# >> | △２二玉(11) |
# >> |--------------|
