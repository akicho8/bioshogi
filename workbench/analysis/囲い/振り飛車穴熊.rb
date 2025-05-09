require "../../setup"

info = Analysis::DefenseInfo.fetch("振り飛車穴熊").static_kif_info
tp info.formatter.container.players.collect { |e| e.skill_set.to_h }
puts info.to_kif
# >> |--------------------------+------------------+------------+--------------------------------|
# >> | attack                   | defense          | technique  | note                           |
# >> |--------------------------+------------------+------------+--------------------------------|
# >> | ["棒銀", "角換わり"]     | ["舟囲い"]       | []         | ["居飛車", "対振り飛車", "対抗形"] |
# >> | ["四間飛車", "角換わり"] | ["振り飛車穴熊"] | ["垂れ歩"] | ["振り飛車", "対抗形"]         |
# >> |--------------------------+------------------+------------+--------------------------------|
# >> 開始日時：1992/01/19
# >> 棋戦：都名人戦
# >> 戦法：四間飛車
# >> 先手：古賀一郎
# >> 後手：森田智明
# >> 場所：東京「将棋会館」
# >> 棋戦詳細：第41回都名人戦決勝トーナメント準決勝
# >> 先手詳細：古賀一郎
# >> 後手詳細：森田智明
# >> 先手の囲い：舟囲い
# >> 後手の囲い：振り飛車穴熊
# >> 先手の戦法：棒銀, 角換わり
# >> 後手の戦法：四間飛車, 角換わり
# >> 手合割：平手
# >> 後手の手筋：垂れ歩
# >> 先手の備考：居飛車, 対振り飛車, 対抗形
# >> 後手の備考：振り飛車, 対抗形
# >> 手数----指手---------消費時間--
# >>    1 ７六歩(77)
# >>    2 ３四歩(33)
# >>    3 ２六歩(27)
# >> *▲備考：居飛車
# >>    4 ４四歩(43)
# >>    5 ４八銀(39)
# >>    6 ４二飛(82)
# >> *△戦法：四間飛車
# >> *△備考：振り飛車
# >>    7 ６八玉(59)
# >>    8 ６二玉(51)
# >>    9 ７八玉(68)
# >>   10 ７二玉(62)
# >>   11 ５六歩(57)
# >>   12 ３二銀(31)
# >>   13 ５八金(49)
# >> *▲囲い：舟囲い
# >>   14 ８二玉(72)
# >>   15 ３六歩(37)
# >>   16 ９二香(91)
# >>   17 ６八銀(79)
# >>   18 ９一玉(82)
# >>   19 ２五歩(26)
# >>   20 ３三角(22)
# >>   21 ３七銀(48)
# >>   22 ８二銀(71)
# >>   23 ２六銀(37)
# >> *▲戦法：棒銀
# >>   24 ７一金(61)
# >> *△囲い：振り飛車穴熊
# >>   25 ９六歩(97)
# >>   26 ７四歩(73)
# >>   27 ３五歩(36)
# >>   28 ４五歩(44)
# >>   29 ３三角成(88)
# >> *▲戦法：角換わり
# >>   30 ３三銀(32)
# >>   31 ５七銀(68)
# >>   32 ７三角打
# >>   33 １八飛(28)
# >>   34 ３五歩(34)
# >>   35 ６五角打
# >>   36 ２二飛(42)
# >>   37 ４三角成(65)
# >>   38 ４二金(41)
# >>   39 ６五馬(43)
# >>   40 ２四歩(23)
# >>   41 ６六馬(65)
# >>   42 ２五歩(24)
# >>   43 ３五銀(26)
# >>   44 ２六歩(25)
# >>   45 ３四歩打
# >>   46 ２七歩成(26)
# >>   47 ３三歩成(34)
# >>   48 ３三金(42)
# >>   49 ４八飛(18)
# >>   50 ３七歩打
# >> *△手筋：垂れ歩
# >>   51 ４六歩(47)
# >>   52 ３八歩成(37)
# >>   53 ４七飛(48)
# >>   54 ２六と(27)
# >>   55 投了
# >> まで54手で後手の勝ち
