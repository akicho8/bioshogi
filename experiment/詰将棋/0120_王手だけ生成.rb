require "../setup"

# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.dimensiton_change([2, 3])
xcontainer = Xcontainer.new
xcontainer.player_at(:black).pieces_add("桂")
xcontainer.board.placement_from_shape <<~EOT
+------+
| ・v玉|
| ・ ・|
| ・ 歩|
+------+
EOT
tp xcontainer.player_at(:black).create_all_hands(promoted_only: true, legal_only: true, mate_only: true)
# >> |----------------|
# >> | ▲１二歩成(13) |
# >> | ▲１二歩(13)   |
# >> | ▲２三桂打     |
# >> |----------------|
