require "./example_helper"

info = Parser.parse("持ち時間：1時間01分")
puts info.to_kif
puts info.to_csa

info = Parser.parse("V2.2\n$TIME_LIMIT: 00:00+05")
puts info.to_kif
puts info.to_csa
# >> 持ち時間：1時間1分
# >> 先手の囲い：
# >> 後手の囲い：
# >> 先手の戦型：
# >> 後手の戦型：
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> V2.2
# >> $TIME_LIMIT:01:01+00
# >> ' 手合割:平手
# >> PI
# >> +
# >> %TORYO
# >> 持ち時間：0分 (1手5秒)
# >> 先手の囲い：
# >> 後手の囲い：
# >> 先手の戦型：
# >> 後手の戦型：
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> V2.2
# >> $TIME_LIMIT:00:00+05
# >> ' 手合割:平手
# >> PI
# >> +
# >> %TORYO
