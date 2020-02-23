require "../example_helper"

# Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([2, 3])
mediator = Mediator.new
mediator.player_at(:black).pieces_add("桂")
mediator.board.placement_from_shape <<~EOT
+------+
| ・v玉|
| ・ ・|
| ・ 歩|
+------+
EOT
tp mediator.player_at(:black).create_all_hands(promoted_only: true, legal_only: true, mate_only: true)
# >> |----------------|
# >> | ▲１二歩成(13) |
# >> | ▲１二歩(13)   |
# >> | ▲２三桂打     |
# >> |----------------|
