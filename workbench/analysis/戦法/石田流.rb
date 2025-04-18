require "../../setup"

info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)
   2 ３四歩(33)
   3 ７五歩(76)
   4 ４二玉(51)
   5 ６六歩(67)
   6 ８四歩(83)
   7 ７八飛(28)
   8 ８五歩(84)
   9 ７六飛(78)
  10 ９四歩(93)
  11 ９六歩(97)
  12 ３二玉(42)
  13 ９七角(88)
  14 ６四歩(63)
  15 ７七桂(89)
  16 ６二銀(71)
  17 ６八銀(79)
EOT
tp info.formatter.container.players.collect { |e| e.skill_set.to_h }
puts info.to_kif
# >> |------------------+----------+-----------+------------------------------------|
# >> | attack           | defense  | technique | note                               |
# >> |------------------+----------+-----------+------------------------------------|
# >> | ["石田流本組み"] | ["居玉"] | []        | ["振り飛車", "対居飛車", "対抗形"] |
# >> | ["力戦"]         | []       | []        | ["居飛車", "対振り飛車", "対抗形"] |
# >> |------------------+----------+-----------+------------------------------------|
# >> 手合割：平手
# >> 先手の戦法：石田流本組み
# >> 後手の戦法：力戦
# >> 先手の囲い：居玉
# >> 先手の備考：振り飛車, 対居飛車, 対抗形
# >> 後手の備考：居飛車, 対振り飛車, 対抗形
# >> 先手の棋風：王道
# >> 後手の棋風：王道
# >> 手数----指手---------消費時間--
# >>    1 ７六歩(77)
# >>    2 ３四歩(33)
# >>    3 ７五歩(76)
# >>    4 ４二玉(51)
# >>    5 ６六歩(67)
# >>    6 ８四歩(83)
# >> *△備考：居飛車
# >>    7 ７八飛(28)
# >> *▲戦法：三間飛車
# >> *▲備考：振り飛車
# >>    8 ８五歩(84)
# >>    9 ７六飛(78)
# >>   10 ９四歩(93)
# >>   11 ９六歩(97)
# >>   12 ３二玉(42)
# >>   13 ９七角(88)
# >>   14 ６四歩(63)
# >>   15 ７七桂(89)
# >> *▲戦法：石田流本組み
# >>   16 ６二銀(71)
# >>   17 ６八銀(79)
# >>   18 投了
# >> まで17手で先手の勝ち
