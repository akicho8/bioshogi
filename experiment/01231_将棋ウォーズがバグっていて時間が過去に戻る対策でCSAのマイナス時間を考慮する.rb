require "./example_helper"

info = Parser.parse(<<~EOT)
+7776FU,T+600
-3334FU,T0
+8877KA,T-10
-2233KA,T0
EOT

tp info.move_infos
# >> |---------+--------------|
# >> | input   | used_seconds |
# >> |---------+--------------|
# >> | +7776FU |          600 |
# >> | -3334FU |            0 |
# >> | +8877KA |          -10 |
# >> | -2233KA |            0 |
# >> |---------+--------------|
