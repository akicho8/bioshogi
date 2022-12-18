require "./setup"

container = Container.create
container.placement_from_bod(<<~EOT)
後手の持駒：
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|
| ・v飛 ・ ・ ・ ・ ・v角 ・|
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|
| 香 桂 銀 金 玉 金 銀 桂 香|
+---------------------------+
先手の持駒：
EOT

player = container.player_at(:black)
evaluator = player.evaluator(evaluator_class: Evaluator::Level2)
evaluator.score                 # => 1
