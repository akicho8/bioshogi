require "../setup"
info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
1 ７六歩(77)    ( 0:01/00:00:01)
2 先手 反則負け ( 0:01/00:00:01)
EOT
p info
puts info.to_kif
































