require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_bod(<<~EOT)
後手の持駒：桂
+---------+
| ・ ・v玉|
| ・ ・ ・|
| ・ 金 ・|
+---------+
先手の持駒：香2
EOT
player = xcontainer.player_at(:black)
player.soldiers_pressure_level  # => 3
player.piece_box.pressure_level # => 2
player.pressure_level           # => 5
player.pressure_rate            # => 0.3125
tp player.pressure_report

player = xcontainer.player_at(:white)
player.soldiers_pressure_level  # => 0
player.piece_box.pressure_level # => 1
player.pressure_level           # => 1
player.pressure_rate            # => 0.0625
tp player.pressure_report
# >> |----------+---------------+------|
# >> | 盤上     | 勢力          | 持駒 |
# >> |----------+---------------+------|
# >> | ▲２三金 |             3 |      |
# >> |          | 1 * 2         | 香2  |
# >> |          | 合計 5        |      |
# >> |          | 終盤率 0.3125 |      |
# >> |          | 序盤率 0.6875 |      |
# >> |----------+---------------+------|
# >> |----------+---------------+------|
# >> | 盤上     | 勢力          | 持駒 |
# >> |----------+---------------+------|
# >> | △１一玉 |             0 |      |
# >> |          | 1 * 1         | 桂1  |
# >> |          | 合計 1        |      |
# >> |          | 終盤率 0.0625 |      |
# >> |          | 序盤率 0.9375 |      |
# >> |----------+---------------+------|
