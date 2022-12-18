require "./setup"

container = Container.create
container.placement_from_bod(<<~EOT)
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
container.execute("43龍(45)")
container.hand_logs.last.to_ki2  # => "４三龍右"
