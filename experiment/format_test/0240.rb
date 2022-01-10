require "../setup"
info = Parser.parse(<<~EOT)
V2.2
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
+7968GI
-3334FU
%TORYO
EOT
puts info.to_kif
# >> 先手の戦型：嬉野流
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 ６八銀(79)
# >> *▲戦型：嬉野流
# >>    2 ３四歩(33)
# >>    3 投了
# >> まで2手で後手の勝ち
