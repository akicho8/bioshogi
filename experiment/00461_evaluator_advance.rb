require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ ・ ・|
| ・ 金 ・|
+---------+
EOT
evaluator = mediator.player_at(:black).evaluator(evaluator_class: EvaluatorAdvance)
s1 = evaluator.score                 # => -38638

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
+---------+
| ・ ・v玉|
| ・ 金 ・|
| ・ ・ ・|
+---------+
EOT
evaluator = mediator.player_at(:black).evaluator(evaluator_class: EvaluatorAdvance)
s2 = evaluator.score                 # => -38633

s2 - s1                         # => 5

