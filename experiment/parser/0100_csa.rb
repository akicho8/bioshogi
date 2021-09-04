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
# >> 先手：A
# >> 後手：B
# >> 先手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ７六歩(77)   (00:06/00:00:06)
# >>    2 投了
# >> まで1手で先手の勝ち
