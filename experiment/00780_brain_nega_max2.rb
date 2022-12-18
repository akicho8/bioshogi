require "./setup"

Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Board.dimensiton_change([2, 3])
container = Container.create
container.board.placement_from_shape <<~EOT
+------+
| ・v香|
| ・v歩|
| ・ 飛|
+------+
  EOT

# ランダムに打って一番得になるものを選ぶため駒損を気にせず歩を取ってしまう
container.player_at(:black).brain.diver_dive(depth_max: 1) # => [1705, [<▲１二飛成(13)>]]

# 香車で取り返されることを予測するため回避する。またその場にいるだけでも取られるので２三に逃げる。また成った方が良いと判断する
container.player_at(:black).brain.diver_dive(depth_max: 2) # => [400, [<▲２三飛成(13)>, <△１三歩成(12)>]]
# >>     0 ▲ ▲１二飛成(13)
# >>     1 △     -1705
# >>     0 ▲ ▲２三飛成(13)
# >>     1 △     -1500
# >>     0 ▲ ★確 ▲１二飛成(13) (1705)
# >>     0 ▲ ▲１二飛成(13)
# >>     1 △     △１二香成(11)
# >>     2 ▲         -3195
# >>     1 △     ★確 △１二香成(11) (3195)
# >>     0 ▲ ▲２三飛成(13)
# >>     1 △     △１三歩成(12)
# >>     2 ▲         +400
# >>     1 △     ★確 △１三歩成(12) (-400)
# >>     0 ▲ ★確 ▲２三飛成(13) (400)
