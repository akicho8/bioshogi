require "./setup"

container = Container::Basic.new
container.placement_from_bod <<~EOT
後手の持駒：
+------+
| ・v玉|
| ・ ・|
| ・ 金|
+------+
先手の持駒：
手数＝1
  EOT
container.current_player.brain.create_all_hands(promoted_only: true).to_a # => [<△２一玉(11)>]
