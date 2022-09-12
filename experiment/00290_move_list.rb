require "./setup"

xcontainer = Xcontainer.new
xcontainer.board.placement_from_shape <<~EOT
+------+
| ・ ・|
| ・ 歩|
| ・ 銀|
+------+
EOT
soldier = xcontainer.board["13"]
soldier.move_list(xcontainer.board).collect(&:to_kif) # => ["▲２二銀成(13)", "▲２二銀(13)", "▲２四銀成(13)", "▲２四銀(13)"]
