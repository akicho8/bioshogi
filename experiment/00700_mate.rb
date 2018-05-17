require "./example_helper"

# Warabi.logger = ActiveSupport::Logger.new(STDOUT)

Board.promotable_disable
Board.dimensiton_change([2, 3])

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：金
+------+
| ・v玉|
| ・v金|
| ・ 玉|
+------+
先手の持駒：
EOT
puts mediator

brain = mediator.player_at(:black).brain(diver_class: NegaAlphaDiver)
# brain.diver_dive(depth_max: 0) # => [60, []]
# brain.diver_dive(depth_max: 1) # => [2520, [<▲１二玉(13)>]]
# brain.diver_dive(depth_max: 2) # => [60, [<▲２四玉(13)>, <△２二玉(11)>]]
# brain.diver_dive(depth_max: 3) # => [60, [<▲２四玉(13)>, <△２二玉(11)>, <▲３三玉(24)>]]
# brain.diver_dive(depth_max: 4) # => [-2460, [<▲２一金打>, <△２一玉(11)>, <▲２四玉(13)>, <△２二玉(21)>]]

tp brain.smart_score_list(depth_max: 2) # => [{:hand=><▲１二玉(13)>, :score=>0, :socre2=>0, :best_pv=>[], :eval_times=>1, :sec=>1.5e-05}, {:hand=><▲２二玉(13)>, :score=>-2460, :socre2=>-2460, :best_pv=>[], :eval_times=>1, :sec=>3.5e-05}, {:hand=><▲２三玉(13)>, :score=>-2460, :socre2=>-2460, :best_pv=>[], :eval_times=>1, :sec=>1.5e-05}]
# >> 後手の持駒：金
# >>   ２ １
# >> +------+
# >> | ・v玉|一
# >> | ・v金|二
# >> | ・ 玉|三
# >> +------+
# >> 先手の持駒：なし
# >> 手数＝0 まで
# >> 
# >> 先手番
# >> |--------------+-------+--------+---------+------------+---------|
# >> | hand         | score | socre2 | best_pv | eval_times | sec     |
# >> |--------------+-------+--------+---------+------------+---------|
# >> | ▲１二玉(13) |     0 |      0 | []      |          1 | 1.5e-05 |
# >> | ▲２二玉(13) | -2460 |  -2460 | []      |          1 | 3.5e-05 |
# >> | ▲２三玉(13) | -2460 |  -2460 | []      |          1 | 1.5e-05 |
# >> |--------------+-------+--------+---------+------------+---------|
