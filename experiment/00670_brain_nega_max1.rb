require "./example_helper"

Bioshogi.logger = ActiveSupport::Logger.new(STDOUT)

Board.dimensiton_change([3, 3])
mediator = Mediator.new
mediator.board.placement_from_shape <<~EOT
+---------+
| ・ ・v歩|
| ・ ・ ・|
| 歩 ・ ・|
+---------+
EOT

tp mediator.player_at(:black).brain.diver_dive(depth_max: 0)
tp mediator.player_at(:black).brain.diver_dive(depth_max: 1)
tp mediator.player_at(:black).brain.diver_dive(depth_max: 2)
# >>     0 ▲ +0
# >> |----|
# >> |  0 |
# >> | [] |
# >> |----|
# >>     0 ▲ ▲３二歩成(33)
# >>     1 △     -1100
# >>     0 ▲ ★確 ▲３二歩成(33) (1100)
# >> |--------------------|
# >> |               1100 |
# >> | [<▲３二歩成(33)>] |
# >> |--------------------|
# >>     0 ▲ ▲３二歩成(33)
# >>     1 △     △１二歩成(11)
# >>     2 ▲         +0
# >>     1 △     ★確 △１二歩成(11) (0)
# >>     0 ▲ ★確 ▲３二歩成(33) (0)
# >> |--------------------------------------|
# >> |                                    0 |
# >> | [<▲３二歩成(33)>, <△１二歩成(11)>] |
# >> |--------------------------------------|
