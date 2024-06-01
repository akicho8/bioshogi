require "../setup"
info = Parser.parse(<<~EOT)
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦型
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
# >> * @pi.board_source
# >> P1-KY-KE-GI-KI-OU-KI-GI-KE *
# >> P2 * -HI *  *  *  *  * -KA *
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  *
# >> P5 *  *  *  *  *  *  *  *  *
# >> P6 *  *  *  *  *  *  *  *  *
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI *
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# >>
# >> * attributes
# >> |-------------------+--------|
# >> | pi.force_preset_info | 香落ち |
# >> |      balance_info | 通常戦 |
# >> |    pi.force_location |        |
# >> |    pi.force_handicap | true   |
# >> |-------------------+--------|
# >>
# >> * pi.header attributes
# >> |----------+--------------|
# >> |     棋戦 | その他の棋戦 |
# >> | 開始日時 | 1938/03/01   |
# >> |     戦型 | その他の戦型 |
# >> | 持ち時間 | 6時間        |
# >> |----------+--------------|
# >>
# >> * pi.header methods (read)
# >> |-------------------+--|
# >> | handicap_validity |  |
# >> |    pi.force_location |  |
# >> |-------------------+--|
# >>
# >> * @pi.board_source
# >> P1-KY-KE-GI-KI-OU-KI-GI-KE *
# >> P2 * -HI *  *  *  *  * -KA *
# >> P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
# >> P4 *  *  *  *  *  *  *  *  *
# >> P5 *  *  *  *  *  *  *  *  *
# >> P6 *  *  *  *  *  *  *  *  *
# >> P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
# >> P8 * +KA *  *  *  *  * +HI *
# >> P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
# >>
# >> * pi.move_infos
# >> |---------+--------------|
# >> | input   | used_seconds |
# >> |---------+--------------|
# >> | -3334FU |              |
# >> | +7776FU |              |
# >> |---------+--------------|
# >>
# >> * @pi.last_action_params
# >> 棋戦：その他の棋戦
# >> 開始日時：1938/03/01
# >> 戦型：その他の戦型
# >> 持ち時間：6時間
# >> 下手の備考：居飛車, 相居飛車
# >> 上手の備考：居飛車, 相居飛車
# >> 手合割：香落ち
# >> 手数----指手---------消費時間--
# >>    1 ３四歩(33)
# >>    2 ７六歩(77)
# >>    3 投了
# >> まで2手で下手の勝ち
