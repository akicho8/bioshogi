require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ ・ ・|
| ・ 金 ・|
+---------+
先手の持駒：飛
EOT

evaluator = mediator.player_at(:black).evaluator(evaluator_class: Evaluator::Level3)
evaluator.danger_level          # => 1
s1 = evaluator.score            # => -36540

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
# >> [:rook, 1]
