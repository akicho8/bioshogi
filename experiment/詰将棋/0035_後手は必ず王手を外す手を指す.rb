require "../example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([2, 3])

mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
| ・v玉|
| ・ 銀|
| ・ 歩|
+------+
EOT
tp mediator.player_at(:white).normal_all_hands(promoted_only: false, legal_only: true)
# >> |--------------|
# >> | △２二玉(11) |
# >> |--------------|
