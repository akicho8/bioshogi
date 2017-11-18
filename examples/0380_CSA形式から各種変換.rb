require "./example_helper"

info = Parser.parse(<<~EOT)
'encoding=Shift_JIS
' ---- Kifu for Windows V7 V7.31 CSA形式棋譜ファイル ----
V2.2
N+akicho8
N-yosui26
$EVENT:レーティング対局室(早指2)
$START_TIME:2017/11/15 0:23:44
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
+7968GI,T5
-3334FU
%TORYO,T16
EOT

puts "-" * 80
puts info.to_kif
puts "-" * 80
puts info.to_ki2
puts "-" * 80
puts info.to_csa
# ~> /Users/ikeda/src/bushido/lib/bushido/parser/csa_parser.rb:56:in `block in parse': undefined local variable or method `md' for #<Bushido::Parser::CsaParser:0x007ff2ee855258> (NameError)
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/csa_parser.rb:55:in `scan'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/csa_parser.rb:55:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:120:in `tap'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:120:in `parse'
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/parser/base.rb:17:in `parse'
# ~> 	from -:3:in `<main>'
