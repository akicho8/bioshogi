require "../../setup"

info = Parser.file_parse("../戦法/アヒル戦法.kif", turn_limit: 42)
puts info.formatter.container
puts info.to_kif
# >> 後手の持駒：桂
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香 ・v金 ・ ・ ・v金v桂v香|一
# >> | ・ ・ ・ ・v玉v銀 ・ ・ ・|二
# >> | ・ ・ ・v銀v歩v歩v歩v歩v角|三
# >> |v歩 ・v歩v歩 ・ ・v飛 ・v歩|四
# >> | ・ 歩 ・ ・ ・ ・ ・ 歩 ・|五
# >> | 歩 ・ 歩 ・ 飛 ・ ・ ・ 歩|六
# >> | ・ ・ ・ 歩 歩 歩 歩 ・ ・|七
# >> | ・ 角 金 銀 玉 銀 ・ ・ 香|八
# >> | 香 ・ ・ ・ ・ ・ 金 桂 ・|九
# >> +---------------------------+
# >> 先手の持駒：桂 歩
# >> 手数＝43 ▲８五歩(86) まで
# >>
# >> 後手番
# >> 先手：鈴木琢光
# >> 後手：阿部晃大
# >> 先手の囲い：アヒル囲い
# >> 後手の囲い：アヒル囲い
# >> 手合割：平手
# >> 先手の戦法：アヒル戦法
# >> 後手の戦法：アヒル戦法
# >> 手数----指手---------消費時間--
# >>    1 ２六歩(27)   (00:00/00:00:00)
# >>    2 ８四歩(83)   (00:00/00:00:00)
# >>    3 ９六歩(97)   (00:00/00:00:00)
# >>    4 １四歩(13)   (00:00/00:00:00)
# >>    5 ２五歩(26)   (00:00/00:00:00)
# >>    6 １三角(22)   (00:00/00:00:00)
# >>    7 ５八玉(59)   (00:00/00:00:00)
# >>    8 ８五歩(84)   (00:00/00:00:00)
# >>    9 ９七角(88)   (00:00/00:00:00)
# >>   10 ５二玉(51)   (00:00/00:00:00)
# >>   11 ２六飛(28)   (00:00/00:00:00)
# >>   12 ８四飛(82)   (00:00/00:00:00)
# >>   13 ６八銀(79)   (00:00/00:00:00)
# >>   14 ４二銀(31)   (00:00/00:00:00)
# >>   15 ７九金(69)   (00:00/00:00:00)
# >>   16 ９四歩(93)   (00:00/00:00:00)
# >>   17 １六歩(17)   (00:00/00:00:00)
# >>   18 ３一金(41)   (00:00/00:00:00)
# >>   19 ４八銀(39)   (00:00/00:00:00)
# >>   20 ６二銀(71)   (00:00/00:00:00)
# >>   21 ３九金(49)   (00:00/00:00:00)
# >> *▲囲い：アヒル囲い
# >> *▲戦法：アヒル戦法
# >>   22 ７一金(61)   (00:00/00:00:00)
# >> *△囲い：アヒル囲い
# >> *△戦法：アヒル戦法
# >>   23 ５六飛(26)   (00:00/00:00:00)
# >>   24 ２二角(13)   (00:00/00:00:00)
# >>   25 ７五角(97)   (00:00/00:00:00)
# >>   26 ３四飛(84)   (00:00/00:00:00)
# >>   27 ７六歩(77)   (00:00/00:00:00)
# >>   28 ６四歩(63)   (00:00/00:00:00)
# >>   29 ６六角(75)   (00:00/00:00:00)
# >>   30 ６三銀(62)   (00:00/00:00:00)
# >>   31 ８八角(66)   (00:00/00:00:00)
# >>   32 ７四歩(73)   (00:00/00:00:00)
# >>   33 ７七桂(89)   (00:00/00:00:00)
# >>   34 ７三桂(81)   (00:00/00:00:00)
# >>   35 ７八金(79)   (00:00/00:00:00)
# >>   36 ３二金(31)   (00:00/00:00:00)
# >>   37 １八香(19)   (00:00/00:00:00)
# >>   38 ３一金(32)   (00:00/00:00:00)
# >>   39 ８五桂(77)   (00:00/00:00:00)
# >>   40 ８五桂(73)   (00:00/00:00:00)
# >>   41 ８六歩(87)   (00:00/00:00:00)
# >>   42 １三角(22)   (00:00/00:00:00)
# >>   43 ８五歩(86)   (00:00/00:00:00)
# >>   44 投了
# >> まで43手で先手の勝ち
