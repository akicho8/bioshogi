require "../example_helper"

info = Parser.parse(<<~EOT)
V2.2
N+A
N-B
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
P+
P-
+
+7776FU,T6
EOT
puts info.to_kif


# info = BoardParser::CsaBoardParser.parse(<<~EOT)
# P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
# P2 * -HI *  *  *  *  * -KA *
# P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# P4 *  *  *  *  *  *  *  *  *
# P5 *  *  *  *  *  *  *  *  *
# P6 *  *  *  *  *  *  *  *  *
# P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# P8 * +KA *  *  *  *  * +HI *
# P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# EOT
# tp info.soldiers
# 
# # info.class                      # => Bioshogi::Parser::CsaParser
# # info.to_kif                     # =>
# ~> /Users/ikeda/src/bioshogi/lib/bioshogi/parser/csa_parser.rb:99:in `parse': P1-KY-KE-GI-KI-OU-KI-GI-KE-KY (RuntimeError)
# ~> P2 * -HI *  *  *  *  * -KA *
# ~> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# ~> P4 *  *  *  *  *  *  *  *  *
# ~> P5 *  *  *  *  *  *  *  *  *
# ~> P6 *  *  *  *  *  *  *  *  *
# ~> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# ~> P8 * +KA *  *  *  *  * +HI *
# ~> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser/base.rb:22:in `tap'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser/base.rb:22:in `parse'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi/parser.rb:25:in `parse'
# ~> 	from -:3:in `<main>'
