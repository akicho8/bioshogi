require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ ・ ・|
| 玉 金 ・|
+---------+
先手の持駒：飛香
EOT

xcontainer.players.each { |e| tp e.pressure_report }
player = xcontainer.player_at(:black)
evaluator = player.evaluator(evaluator_class: Evaluator::Level1)
evaluator.score               # => 3930
# >> |----------+---------------+------|
# >> | 盤上     | 勢力          | 持駒 |
# >> |----------+---------------+------|
# >> | ▲３三玉 |             4 |      |
# >> | ▲２三金 |             3 |      |
# >> |          | 3 * 1         | 飛1  |
# >> |          | 1 * 1         | 香1  |
# >> |          | 合計 11       |      |
# >> |          | 終盤率 0.6875 |      |
# >> |          | 序盤率 0.3125 |      |
# >> |----------+---------------+------|
# >> |----------+------------|
# >> | 盤上     | 勢力       |
# >> |----------+------------|
# >> | △１一玉 |          0 |
# >> |          | 合計 0     |
# >> |          | 終盤率 0.0 |
# >> |          | 序盤率 1.0 |
# >> |----------+------------|
