require "#{__dir__}/setup"

container = Container::Basic.new
container.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ ・ ・|
| 玉 金 ・|
+---------+
先手の持駒：飛香
EOT

container.players.each { |e| tp e.pressure_report }
player = container.player_at(:black)
evaluator = player.evaluator(evaluator_class: Evaluator::Level4)
evaluator.score            # => 3958
tp evaluator.score_compute_report

# container = Container::Basic.new
# container.placement_from_bod(<<~EOT)
# +---------+
# | ・ ・v玉|
# | ・ 金 ・|
# | ・ ・ ・|
# +---------+
# EOT
# evaluator = container.player_at(:black).evaluator(evaluator_class: Evaluator::Level3)
# s2 = evaluator.score                 # => -38635
#
# s2 - s1                         # => 5
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
# >> |---------+----------------+--------+------+-------+--------------|
# >> | 先後    | 駒箱(常時加算) | 駒組み | 終盤 | 合計  | 差(自分基準) |
# >> |---------+----------------+--------+------+-------+--------------|
# >> | ▲ 自分 |           2730 |  41200 |  110 | 44040 |              |
# >> | △      |              0 |  40000 |   82 | 40082 |              |
# >> |         |                |        |      |       |         3958 |
# >> |---------+----------------+--------+------+-------+--------------|
