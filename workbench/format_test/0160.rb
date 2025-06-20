require "../setup"
info = Parser.parse(<<~EOT)
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦法
$TIME_LIMIT:6時間
' 手合割:香落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE *
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-3334FU
+7776FU
EOT
p info
puts info.to_kif

































































