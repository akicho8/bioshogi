require "../setup"
info = Parser.parse(<<~EOT, typical_error_case: :embed)
+7968GI,,T30
-3334FU,T1
+2726FU
-8384FU,T2
%TORYO,,,T1
EOT
# p info
puts info.to_csa
# >> V2.2
# >> ' 手合割:平手
# >> PI
# >> +
# >> +7968GI,T30
# >> -3334FU,T1
# >> +2726FU,T0
# >> -8384FU,T2
# >> %TORYO,T1
# >> 
