require "../setup"
info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
1 ７六歩(77)    ( 0:01/00:00:01)
2 先手 反則負け ( 0:01/00:00:01)
EOT
p info
puts info.to_kif
# >> * attributes
# >> |-------------------+--------|
# >> | pi.force_preset_info | 平手   |
# >> |      balance_info | 通常戦 |
# >> |    pi.force_location |        |
# >> |    pi.force_handicap |        |
# >> |-------------------+--------|
# >>
# >> * pi.header
# >> |--------+------|
# >> | 手合割 | 平手 |
# >> |--------+------|
# >>
# >> * pi.move_infos
# >> |-------------+------------+---------------+--------------|
# >> | turn_number | input      | clock_part    | used_seconds |
# >> |-------------+------------+---------------+--------------|
# >> |           1 | ７六歩(77) | 0:01/00:00:01 |            1 |
# >> |-------------+------------+---------------+--------------|
# >>
# >> * @pi.last_action_params
# >> |-----------------+---------------|
# >> |     turn_number | 2             |
# >> | last_action_key | 先手 反則負け |
# >> |    used_seconds | 1             |
# >> |-----------------+---------------|
# >> 手合割：平手
# >> 先手の備考：居飛車, 相居飛車
# >> 後手の備考：居飛車, 相居飛車
# >> 手数----指手---------消費時間--
# >>    1 ７六歩(77)   (00:01/00:00:01)
# >> *先手 反則負け
