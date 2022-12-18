require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.dimensiton_change([2, 3])
container = Container.create
container.player_at(:black).pieces_add("桂")
container.board.placement_from_shape <<~EOT
+------+
| ・v玉|
| ・ ・|
| ・ 歩|
+------+
EOT
tp container.player_at(:black).create_all_hands(promoted_only: true, legal_only: true, mate_only: true)
# >> |----------------|
# >> | ▲１二歩成(13) |
# >> | ▲１二歩(13)   |
# >> | ▲２三桂打     |
# >> |----------------|
