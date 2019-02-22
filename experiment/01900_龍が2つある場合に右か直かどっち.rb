require "./example_helper"

mediator = Mediator.new
mediator.placement_from_bod(<<~EOT)
上手の持駒：
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ 龍 ・ ・ ・ ・|
| ・ ・ ・ ・ ・ 龍 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
下手の持駒：なし
手数＝1

先手番
EOT
mediator.execute("43龍(45)")
mediator.hand_logs.last.to_ki2  # => "４三龍右"
