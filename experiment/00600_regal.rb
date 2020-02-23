require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod <<~EOT
後手の持駒：
+------+
| ・v玉|
| ・ ・|
| ・ 金|
+------+
先手の持駒：
手数＝1
  EOT
mediator.current_player.brain.create_all_hands(with_no_promoted: true).to_a # => [<△２一玉(11)>]
