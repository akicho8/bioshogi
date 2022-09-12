require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_bod(<<~EOT)
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
xcontainer.execute("43龍(45)")
xcontainer.hand_logs.last.to_ki2  # => "４三龍右"
