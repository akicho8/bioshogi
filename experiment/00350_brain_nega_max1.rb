require "./example_helper"

Warabi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([3, 3])
mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+---------+
| ・ ・v歩|
| ・ ・ ・|
| 歩 ・ ・|
+---------+
EOT

tp mediator.player_at(:black).brain.nega_alpha_run(depth_max: 0)
tp mediator.player_at(:black).brain.nega_alpha_run(depth_max: 1)
tp mediator.player_at(:black).brain.nega_alpha_run(depth_max: 2)
# >> 0 ▲ 評価 0
# >> |------------+----|
# >> |      score | 0  |
# >> | eval_times | 1  |
# >> |    readout | [] |
# >> |------------+----|
# >> 0 ▲ 試指 ▲３二歩成(33) (1/1)
# >> 1 △     評価 -1100
# >> 0 ▲ ★確 ▲３二歩成(33) 読み数:1
# >> |------------+---------------------|
# >> |       hand | ▲３二歩成(33)      |
# >> |      score | 1100                |
# >> | eval_times | 1                   |
# >> |    readout | [#<▲３二歩成(33)>] |
# >> |------------+---------------------|
# >> 0 ▲ 試指 ▲３二歩成(33) (1/1)
# >> 1 △     試指 △１二歩成(11) (1/1)
# >> 2 ▲         評価 0
# >> 1 △     ★確 △１二歩成(11) 読み数:1
# >> 0 ▲ ★確 ▲３二歩成(33) 読み数:1
# >> |------------+----------------------------------------|
# >> |       hand | ▲３二歩成(33)                         |
# >> |      score | 0                                      |
# >> | eval_times | 1                                      |
# >> |    readout | [#<▲３二歩成(33)>, #<△１二歩成(11)>] |
# >> |------------+----------------------------------------|
