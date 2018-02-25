require "./example_helper"

Warabi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([2, 3])
mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+------+
| ・v香|
| ・v歩|
| ・ 飛|
+------+
  EOT

# ランダムに打って一番得になるものを選ぶため駒損を気にせず歩を取ってしまう
mediator.player_at(:black).brain.nega_alpha_run(depth_max: 1) # => {:hand=>#<▲１二飛成(13)>, :score=>1705, :eval_times=>1, :readout=>[#<▲１二飛成(13)>]}

# 香車で取り返されることを予測するため回避する。またその場にいるだけでも取られるので２三に逃げる。また成った方が良いと判断する
mediator.player_at(:black).brain.nega_alpha_run(depth_max: 2) # => {:hand=>#<▲２三飛成(13)>, :score=>400, :eval_times=>2, :readout=>[#<▲２三飛成(13)>, #<△１三歩成(12)>]}
# >> 0 ▲ 試指 ▲１二飛成(13) (0)
# >> 1 △     評価 -1705
# >> 0 ▲ 試指 ▲２三飛成(13) (1)
# >> 1 △     評価 -1500
# >> 0 ▲ ★確 ▲１二飛成(13) 読み数:2
# >> 0 ▲ 試指 ▲１二飛成(13) (0)
# >> 1 △     試指 △１二香成(11) (0)
# >> 2 ▲         評価 -3195
# >> 1 △     ★確 △１二香成(11) 読み数:1
# >> 0 ▲ 試指 ▲２三飛成(13) (1)
# >> 1 △     試指 △１三歩成(12) (0)
# >> 2 ▲         評価 400
# >> 1 △     ★確 △１三歩成(12) 読み数:2
# >> 0 ▲ ★確 ▲２三飛成(13) 読み数:2
