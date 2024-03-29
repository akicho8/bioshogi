require "../setup"

info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
   1 26歩
   2 24歩
   3 25歩
   4 同歩
   5 同飛
   6 32金
   7 22飛不成
EOT
puts info.to_kif
# >> 手合割：平手
# >> 先手の備考：居飛車, 飛車不成, 相居飛車, 居玉, 相居玉
# >> 後手の備考：居飛車, 相居飛車, 居玉, 相居玉
# >> 手数----指手---------消費時間--
# >>    1 ２六歩(27)   (00:00/00:00:00)
# >> *▲備考：居飛車
# >>    2 ２四歩(23)   (00:00/00:00:00)
# >>    3 ２五歩(26)   (00:00/00:00:00)
# >>    4 ２五歩(24)   (00:00/00:00:00)
# >>    5 ２五飛(28)   (00:00/00:00:00)
# >>    6 ３二金(41)   (00:00/00:00:00)
# >>    7 ２二飛(25)   (00:00/00:00:00)
# >> *▲備考：飛車不成
# >>    8 投了
# >> まで7手で先手の勝ち
