require "../setup"

Dimension::DimensionRow.promotable_disabled
Dimension.wh_change([2, 3])

container = Container::Basic.new
container.board.placement_from_shape <<~EOT
+------+
|v香v玉|
|v歩 ・|
| ・ 銀|
+------+
EOT
player = container.player_at(:black)
player.move_hands(legal_only: true, mate_only: true).collect(&:to_kif).join(" ")   # => "▲２二銀(13) ▲１二銀(13)"
