require "./example_helper"

info = Parser.parse(<<~EOT)
V2.2
PI82HI22KA
+
+7968GI,T5
-3334FU
%TORYO,T16
EOT

puts info.to_csa
# >> V2.2
# >> PI
# >> +
# >> +7968GI,T5
# >> -3334FU,T0
# >> %TORYO,T16
