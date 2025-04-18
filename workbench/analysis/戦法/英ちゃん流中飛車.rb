require "../../setup"

info = Parser.parse <<~EOS
*詳細URL：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205
*ぴよ将棋：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205/piyo_shogi
*KENTO：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205/kento
先手：Taichan0601 2級
後手：HyperTakeman 八段
開始日時：2024/02/13 13:52:05
棋戦：将棋ウォーズ(3分切れ負け)
持ち時間：3分
先手の戦法：嬉野流, 原始中飛車, アヒル戦法
先手の囲い：無敵囲い, アヒル囲い
後手の囲い：金盾囲い
先手の手筋：金底の歩, 腹銀, 桂頭の銀
後手の手筋：ふんどしの桂, 継ぎ桂
先手の備考：振り飛車, 対抗形
後手の備考：居飛車, 対振り飛車, 対抗形
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:01/00:00:01)
*▲戦法：嬉野流
   2 ８四歩(83)   (00:00/00:00:00)
*△備考：居飛車
   3 ５八飛(28)   (00:02/00:00:03)
*▲戦法：原始中飛車
*▲備考：振り飛車
   4 ８五歩(84)   (00:01/00:00:01)
   5 ４八銀(39)   (00:04/00:00:07)
*▲囲い：無敵囲い
   6 ８六歩(85)   (00:03/00:00:04)
   7 ８六歩(87)   (00:01/00:00:08)
   8 ８六飛(82)   (00:01/00:00:05)
   9 ７八金(69)   (00:02/00:00:10)
  10 ８二飛(86)   (00:00/00:00:05)
  11 ８七歩打     (00:00/00:00:10)
  12 ７二銀(71)   (00:01/00:00:06)
  13 ５六歩(57)   (00:01/00:00:11)
  14 ６四歩(63)   (00:02/00:00:08)
  15 ５五歩(56)   (00:01/00:00:12)
  16 ６三銀(72)   (00:01/00:00:09)
  17 ５六飛(58)   (00:00/00:00:12)
  18 ４二玉(51)   (00:02/00:00:11)
  19 ７六歩(77)   (00:03/00:00:15)
  20 ７四歩(73)   (00:02/00:00:13)
  21 ７七角(88)   (00:01/00:00:16)
  22 ３二玉(42)   (00:01/00:00:14)
  23 ３九金(49)   (00:02/00:00:18)
  24 ４二銀(31)   (00:01/00:00:15)
  25 ８六歩(87)   (00:01/00:00:19)
  26 ３四歩(33)   (00:01/00:00:16)
  27 ５八玉(59)   (00:00/00:00:19)
  28 ３三銀(42)   (00:00/00:00:16)
  29 ７九金(78)   (00:03/00:00:22)
*▲戦法：アヒル戦法
*▲囲い：アヒル囲い
  30 ４四銀(33)   (00:01/00:00:17)
  31 ３六飛(56)   (00:10/00:00:32)
  32 ３五歩(34)   (00:03/00:00:20)
  33 ５六飛(36)   (00:01/00:00:33)
  34 ６五歩(64)   (00:02/00:00:22)
  35 ４九玉(58)   (00:04/00:00:37)
  36 ５二金(61)   (00:05/00:00:27)
  37 ３八玉(49)   (00:01/00:00:38)
  38 ４二金(52)   (00:01/00:00:28)
*△囲い：金盾囲い
  39 ５七銀(68)   (00:02/00:00:40)
  40 ６四銀(63)   (00:05/00:00:33)
  41 ４六銀(57)   (00:02/00:00:42)
  42 ７五歩(74)   (00:01/00:00:34)
  43 １六歩(17)   (00:05/00:00:47)
  44 ７二飛(82)   (00:03/00:00:37)
  45 ７五歩(76)   (00:01/00:00:48)
  46 ７五飛(72)   (00:01/00:00:38)
  47 ５四歩(55)   (00:03/00:00:51)
  48 ５四歩(53)   (00:09/00:00:47)
  49 ５四飛(56)   (00:01/00:00:52)
  50 ５三金(42)   (00:00/00:00:47)
  51 ５六飛(54)   (00:10/00:01:02)
  52 ７六歩打     (00:02/00:00:49)
  53 ６八角(77)   (00:01/00:01:03)
  54 ５五歩打     (00:01/00:00:50)
  55 ５九飛(56)   (00:03/00:01:06)
  56 ６六歩(65)   (00:02/00:00:52)
  57 ７八金(79)   (00:11/00:01:17)
  58 ８八歩打     (00:01/00:00:53)
  59 ６六歩(67)   (00:04/00:01:21)
  60 ８九歩成(88) (00:01/00:00:54)
  61 ８九飛(59)   (00:00/00:01:21)
  62 ５六桂打     (00:01/00:00:55)
*△手筋：ふんどしの桂
  63 ５九角(68)   (00:02/00:01:23)
  64 ４八桂成(56) (00:03/00:00:58)
  65 ４八金(39)   (00:00/00:01:23)
  66 ７七銀打     (00:02/00:01:00)
  67 ７九歩打     (00:05/00:01:28)
*▲手筋：金底の歩
  68 ６六銀成(77) (00:01/00:01:01)
  69 ８七飛(89)   (00:05/00:01:33)
  70 ５六歩(55)   (00:08/00:01:09)
  71 ８五歩(86)   (00:02/00:01:35)
  72 ７三桂(81)   (00:03/00:01:12)
  73 ８六角(59)   (00:02/00:01:37)
  74 ６五飛(75)   (00:05/00:01:17)
  75 ６七歩打     (00:02/00:01:39)
  76 ７七成銀(66) (00:12/00:01:29)
  77 ７七金(78)   (00:01/00:01:40)
  78 ７七歩成(76) (00:01/00:01:30)
  79 ７七飛(87)   (00:01/00:01:41)
  80 ７六歩打     (00:01/00:01:31)
  81 ８七飛(77)   (00:02/00:01:43)
  82 ７七金打     (00:08/00:01:39)
  83 ７七角(86)   (00:03/00:01:46)
  84 ７七歩成(76) (00:01/00:01:40)
  85 ７七飛(87)   (00:00/00:01:46)
  86 ８五飛(65)   (00:02/00:01:42)
  87 ３四桂打     (00:02/00:01:48)
  88 ３三角(22)   (00:02/00:01:44)
  89 ２二銀打     (00:02/00:01:50)
*▲手筋：腹銀, 桂頭の銀
  90 ２二角(33)   (00:01/00:01:45)
  91 ２二桂成(34) (00:01/00:01:51)
  92 ２二玉(32)   (00:00/00:01:45)
  93 ９六角打     (00:04/00:01:55)
  94 ８一飛(85)   (00:06/00:01:51)
  95 ７二金打     (00:03/00:01:58)
  96 ３二金(41)   (00:26/00:02:17)
  97 ８一金(72)   (00:01/00:01:59)
  98 ５七銀打     (00:01/00:02:18)
  99 ５八歩打     (00:07/00:02:06)
 100 ４八銀成(57) (00:01/00:02:19)
 101 ４八玉(38)   (00:01/00:02:07)
 102 ６五桂打     (00:00/00:02:19)
*△手筋：継ぎ桂
 103 ７八飛(77)   (00:03/00:02:10)
 104 ２八角打     (00:07/00:02:26)
 105 ８二飛打     (00:01/00:02:11)
 106 １九角成(28) (00:02/00:02:28)
 107 ４一角成(96) (00:02/00:02:13)
 108 ５二香打     (00:01/00:02:29)
 109 ６六歩(67)   (00:04/00:02:17)
 110 ５七歩成(56) (00:02/00:02:31)
 111 ５七歩(58)   (00:01/00:02:18)
 112 ２九馬(19)   (00:01/00:02:32)
 113 ６五歩(66)   (00:01/00:02:19)
 114 ３一金打     (00:01/00:02:33)
 115 ３四桂打     (00:01/00:02:20)
 116 ３三玉(22)   (00:01/00:02:34)
 117 ５一馬(41)   (00:01/00:02:21)
 118 ４二桂打     (00:01/00:02:35)
 119 ４二桂成(34) (00:02/00:02:23)
 120 ４二金(31)   (00:00/00:02:35)
 121 ６四歩(65)   (00:01/00:02:24)
 122 ６五桂(73)   (00:01/00:02:36)
 123 ２五銀打     (00:02/00:02:26)
 124 ２四歩(23)   (00:04/00:02:40)
 125 ３四銀打     (00:02/00:02:28)
 126 ２二玉(33)   (00:00/00:02:40)
 127 ２四銀(25)   (00:00/00:02:28)
 128 ５四桂打     (00:04/00:02:44)
 129 ４二馬(51)   (00:03/00:02:31)
 130 ４二金(32)   (00:01/00:02:45)
 131 ２三銀成(34) (00:04/00:02:35)
 132 ３一玉(22)   (00:01/00:02:46)
 133 ３四桂打     (00:01/00:02:36)
 134 ４六桂(54)   (00:03/00:02:49)
 135 ７一飛成(78) (00:03/00:02:39)
 136 ４一銀打     (00:01/00:02:50)
 137 ２二金打     (00:01/00:02:40)
 138 詰み
まで137手で先手の勝ち
EOS
puts info.formatter.container
puts info.to_ki2
# >> 後手の持駒：角 歩
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香 金 龍 ・ ・v銀v玉v桂v香|一
# >> | ・ 飛 ・ ・v香v金 ・ 金 ・|二
# >> |v歩 ・ ・ ・v金v歩 ・ 全v歩|三
# >> | ・ ・ ・ 歩 ・v銀 桂 銀 ・|四
# >> | ・ ・ ・v桂 ・ ・v歩 ・ ・|五
# >> | ・ ・ ・ ・ ・v桂 ・ ・ 歩|六
# >> | 歩 ・ ・ ・ 歩 歩 歩 歩 ・|七
# >> | ・ ・ ・ ・ ・ 玉 ・ ・ ・|八
# >> | 香 ・ 歩 ・ ・ ・ ・v馬 ・|九
# >> +---------------------------+
# >> 先手の持駒：歩五
# >> 手数＝137 ▲２二金打 まで
# >> 後手番
# >> *詳細URL：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205
# >> *ぴよ将棋：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205/piyo_shogi
# >> *KENTO：https://www.shogi-extend.com/swars/battles/Taichan0601-HyperTakeman-20240213_135205/kento
# >> 先手：Taichan0601 2級
# >> 後手：HyperTakeman 八段
# >> 開始日時：2024/02/13 13:52:05
# >> 棋戦：将棋ウォーズ(3分切れ負け)
# >> 持ち時間：3分
# >> 先手の戦法：嬉野流, 英ちゃん流中飛車, アヒル戦法
# >> 先手の囲い：無敵囲い, アヒル囲い
# >> 後手の囲い：金盾囲い
# >> 先手の手筋：金底の歩, 腹銀, 桂頭の銀
# >> 後手の手筋：ふんどしの桂, 継ぎ桂
# >> 先手の備考：振り飛車, 対抗形
# >> 後手の備考：居飛車, 対振り飛車, 対抗形
# >> 手合割：平手
# >>
# >> ▲６八銀 △８四歩   ▲５八飛     △８五歩   ▲４八銀   △８六歩   ▲同　歩   △同　飛
# >> ▲７八金 △８二飛   ▲８七歩     △７二銀   ▲５六歩   △６四歩   ▲５五歩   △６三銀
# >> ▲５六飛 △４二玉   ▲７六歩     △７四歩   ▲７七角   △３二玉   ▲３九金   △４二銀
# >> ▲８六歩 △３四歩   ▲５八玉     △３三銀   ▲７九金   △４四銀   ▲３六飛   △３五歩
# >> ▲５六飛 △６五歩   ▲４九玉     △５二金右 ▲３八玉   △４二金寄 ▲５七銀左 △６四銀
# >> ▲４六銀 △７五歩   ▲１六歩     △７二飛   ▲７五歩   △同　飛   ▲５四歩   △同　歩
# >> ▲同　飛 △５三金   ▲５六飛     △７六歩   ▲６八角   △５五歩   ▲５九飛   △６六歩
# >> ▲７八金 △８八歩   ▲６六歩     △８九歩成 ▲同　飛   △５六桂   ▲５九角   △４八桂成
# >> ▲同　金 △７七銀   ▲７九歩     △６六銀成 ▲８七飛   △５六歩   ▲８五歩   △７三桂
# >> ▲８六角 △６五飛   ▲６七歩     △７七成銀 ▲同　金   △同歩成   ▲同　飛   △７六歩
# >> ▲８七飛 △７七金   ▲同　角     △同歩成   ▲同　飛   △８五飛   ▲３四桂   △３三角
# >> ▲２二銀 △同　角   ▲同桂成     △同　玉   ▲９六角   △８一飛   ▲７二金   △３二金
# >> ▲８一金 △５七銀   ▲５八歩     △４八銀成 ▲同　玉   △６五桂打 ▲７八飛   △２八角
# >> ▲８二飛 △１九角成 ▲４一角成   △５二香   ▲６六歩   △５七歩成 ▲同　歩   △２九馬
# >> ▲６五歩 △３一金打 ▲３四桂     △３三玉   ▲５一馬   △４二桂   ▲同桂成   △同金上
# >> ▲６四歩 △６五桂   ▲２五銀     △２四歩   ▲３四銀打 △２二玉   ▲２四銀   △５四桂
# >> ▲４二馬 △同　金   ▲２三銀左成 △３一玉   ▲３四桂   △４六桂   ▲７一飛成 △４一銀
# >> ▲２二金
# >> まで137手で先手の勝ち
