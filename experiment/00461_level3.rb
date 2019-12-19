require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ ・ ・|
| ・ 金 ・|
+---------+
先手の持駒：飛香
EOT

evaluator = mediator.player_at(:black).evaluator(evaluator_class: Evaluator::Level3)
player = mediator.player_at(:black)
player.soldiers_pressure_level  # => 3
player.piece_box.pressure_level # => 4
player.pressure_level           # => 7
tp evaluator.danger_level_at
tp mediator.player_at(:black).pressure_level_report
tp mediator.player_at(:white).pressure_level_report


s1 = evaluator.score            # => -36000.0

# mediator = Mediator.new
# mediator.placement_from_bod(<<~EOT)
# +---------+
# | ・ ・v玉|
# | ・ 金 ・|
# | ・ ・ ・|
# +---------+
# EOT
# evaluator = mediator.player_at(:black).evaluator(evaluator_class: Evaluator::Level3)
# s2 = evaluator.score                 # => -38635
# 
# s2 - s1                         # => 5
# >> |----+--------|
# >> | ▲ | 0.4375 |
# >> | △ | 0.0    |
# >> |----+--------|
# >> |----------+---------------+------|
# >> | 盤上     | 勢力          | 持駒 |
# >> |----------+---------------+------|
# >> | ▲２三金 |             3 |      |
# >> |          |             3 | 飛   |
# >> |          |             1 | 香   |
# >> |          | 合計 7        |      |
# >> |          | 終盤率 0.4375 |      |
# >> |          | 序盤率 0.5625 |      |
# >> |----------+---------------+------|
# >> |----------+------------|
# >> | 盤上     | 勢力       |
# >> |----------+------------|
# >> | △１一玉 |          0 |
# >> |          | 合計 0     |
# >> |          | 終盤率 0.0 |
# >> |          | 序盤率 1.0 |
# >> |----------+------------|
