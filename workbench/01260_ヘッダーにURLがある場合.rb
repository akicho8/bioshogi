require "./setup"

info = Parser.parse("URL：http://example.net/")
puts info.to_kif
# >> URL：http://example.net/
# >> 手合割：平手
# >> 手数----指手---------消費時間--
# >>    1 投了
# >> まで0手で後手の勝ち
