require "./setup"

bp = Analysis::DefenseInfo["四段端玉"].board_parser
tp bp.other_objects_loc_ary           # => {:black=>{"◇"=>[{:place=>#<Bioshogi::Place ９五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ８五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ７五>, :prefix_char=>" ", :something=>"◇"}], "◆"=>[{:place=>#<Bioshogi::Place ８六>, :prefix_char=>" ", :something=>"◆"}, {:place=>#<Bioshogi::Place ７六>, :prefix_char=>" ", :something=>"◆"}]}, :white=>{"◇"=>[{:place=>#<Bioshogi::Place １五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ２五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ３五>, :prefix_char=>" ", :something=>"◇"}], "◆"=>[{:place=>#<Bioshogi::Place ２四>, :prefix_char=>" ", :something=>"◆"}, {:place=>#<Bioshogi::Place ３四>, :prefix_char=>" ", :something=>"◆"}]}}
tp bp.other_objects_loc_ary[:black]   # => {"◇"=>[{:place=>#<Bioshogi::Place ９五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ８五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ７五>, :prefix_char=>" ", :something=>"◇"}], "◆"=>[{:place=>#<Bioshogi::Place ８六>, :prefix_char=>" ", :something=>"◆"}, {:place=>#<Bioshogi::Place ７六>, :prefix_char=>" ", :something=>"◆"}]}
tp bp.other_objects_loc_ary[:black]["◆"] # => [{:place=>#<Bioshogi::Place ８六>, :prefix_char=>" ", :something=>"◆"}, {:place=>#<Bioshogi::Place ７六>, :prefix_char=>" ", :something=>"◆"}]
tp tp bp.trigger_soldiers

info = Parser.file_parse("囲い/四段端玉.kif")
puts info.formatter.container
puts info.to_kif
# >> |-------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | black | {"◇"=>[{:place=>#<Bioshogi::Place ９五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ８五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ７五>, :prefix_char=>" ", :something=>"◇"}], "◆"=>[{:place=>#<Bioshogi::Place ８六>, :prefix_cha... |
# >> | white | {"◇"=>[{:place=>#<Bioshogi::Place １五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ２五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ３五>, :prefix_char=>" ", :something=>"◇"}], "◆"=>[{:place=>#<Bioshogi::Place ２四>, :prefix_cha... |
# >> |-------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |----+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | ◇ | [{:place=>#<Bioshogi::Place ９五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ８五>, :prefix_char=>" ", :something=>"◇"}, {:place=>#<Bioshogi::Place ７五>, :prefix_char=>" ", :something=>"◇"}] |
# >> | ◆ | [{:place=>#<Bioshogi::Place ８六>, :prefix_char=>" ", :something=>"◆"}, {:place=>#<Bioshogi::Place ７六>, :prefix_char=>" ", :something=>"◆"}]                                                                       |
# >> |----+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-------+-------------+-----------|
# >> | place | prefix_char | something |
# >> |-------+-------------+-----------|
# >> | ８六  |             | ◆        |
# >> | ７六  |             | ◆        |
# >> |-------+-------------+-----------|
# >> |----------|
# >> | ▲９六玉 |
# >> |----------|
# >> |----------|
# >> | ▲９六玉 |
# >> |----------|
# >> 後手の持駒：飛 角 金 銀 桂二 香三 歩六
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | 馬 ・ ・ ・ と ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | 玉 圭 ・ ・ ・ ・ ・ ・v玉|三
# >> | 歩 ・ ・ ・ ・v龍 ・v銀 ・|四
# >> | ・v歩 歩 銀v歩v金v歩v銀 ・|五
# >> | ・ ・ 金 ・ ・ ・ ・ ・ ・|六
# >> | ・vと ・v歩 桂 ・ 歩 ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・vと|八
# >> | 香 ・ ・ 歩 ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：金 歩
# >> 手数＝184 △１三玉(22) まで
# >>
# >> 先手番
# >> 開始日時：1970/05/01 09:00:00
# >> 棋戦：名人戦
# >> 場所：東京都千代田区紀尾井町「福田家」
# >> 持ち時間：9時間
# >> 手合割：平手
# >> 先手：灘蓮照
# >> 後手：大山康晴
# >> 戦法：その他の戦法
# >> 先手の囲い：四段端玉
# >> 後手の囲い：あずまや囲い
# >> 先手の戦法：玉頭位取り
# >> 先手の手筋：垂れ歩
# >> 後手の手筋：垂れ歩, 桂頭の銀
# >> 手数----指手---------消費時間--
# >>    1 ７六歩(77)   (00:00/00:00:00)
# >>    2 ３四歩(33)   (00:00/00:00:00)
# >>    3 ６六歩(67)   (00:00/00:00:00)
# >>    4 ４二銀(31)   (00:00/00:00:00)
# >>    5 ６八銀(79)   (00:00/00:00:00)
# >>    6 ５四歩(53)   (00:00/00:00:00)
# >>    7 ５六歩(57)   (00:00/00:00:00)
# >>    8 ４四歩(43)   (00:00/00:00:00)
# >>    9 ６七銀(68)   (00:00/00:00:00)
# >>   10 ４三銀(42)   (00:00/00:00:00)
# >>   11 ２六歩(27)   (00:00/00:00:00)
# >>   12 ３五歩(34)   (00:00/00:00:00)
# >>   13 ２五歩(26)   (00:00/00:00:00)
# >>   14 ３三角(22)   (00:00/00:00:00)
# >>   15 ６五歩(66)   (00:00/00:00:00)
# >>   16 ６二銀(71)   (00:00/00:00:00)
# >>   17 ４八銀(39)   (00:00/00:00:00)
# >>   18 ５三銀(62)   (00:00/00:00:00)
# >>   19 ５七銀(48)   (00:00/00:00:00)
# >>   20 ３四銀(43)   (00:00/00:00:00)
# >> *△囲い：あずまや囲い
# >>   21 ６八玉(59)   (00:00/00:00:00)
# >>   22 ３二金(41)   (00:00/00:00:00)
# >>   23 ７八玉(68)   (00:00/00:00:00)
# >>   24 ６四歩(63)   (00:00/00:00:00)
# >>   25 ６四歩(65)   (00:00/00:00:00)
# >>   26 ６四銀(53)   (00:00/00:00:00)
# >>   27 ７七桂(89)   (00:00/00:00:00)
# >>   28 ４一玉(51)   (00:00/00:00:00)
# >>   29 ９六歩(97)   (00:00/00:00:00)
# >>   30 ５二金(61)   (00:00/00:00:00)
# >>   31 ６六銀(67)   (00:00/00:00:00)
# >>   32 ８四歩(83)   (00:00/00:00:00)
# >>   33 ６五歩打     (00:00/00:00:00)
# >>   34 ５三銀(64)   (00:00/00:00:00)
# >>   35 ５八金(49)   (00:00/00:00:00)
# >>   36 ８五歩(84)   (00:00/00:00:00)
# >>   37 ６七金(58)   (00:00/00:00:00)
# >>   38 ４五歩(44)   (00:00/00:00:00)
# >>   39 ７五歩(76)   (00:00/00:00:00)
# >> *▲戦法：玉頭位取り
# >>   40 ３一玉(41)   (00:00/00:00:00)
# >>   41 ７六金(67)   (00:00/00:00:00)
# >>   42 ２二玉(31)   (00:00/00:00:00)
# >>   43 ６八金(69)   (00:00/00:00:00)
# >>   44 １四歩(13)   (00:00/00:00:00)
# >>   45 １六歩(17)   (00:00/00:00:00)
# >>   46 ４四銀(53)   (00:00/00:00:00)
# >>   47 ９五歩(96)   (00:00/00:00:00)
# >>   48 ６三金(52)   (00:00/00:00:00)
# >>   49 ６七金(68)   (00:00/00:00:00)
# >>   50 ４二飛(82)   (00:00/00:00:00)
# >>   51 ７九角(88)   (00:00/00:00:00)
# >>   52 ５二飛(42)   (00:00/00:00:00)
# >>   53 ６八角(79)   (00:00/00:00:00)
# >>   54 ５一飛(52)   (00:00/00:00:00)
# >>   55 ７九角(68)   (00:00/00:00:00)
# >>   56 ７四歩(73)   (00:00/00:00:00)
# >>   57 ７四歩(75)   (00:00/00:00:00)
# >>   58 ７四金(63)   (00:00/00:00:00)
# >>   59 ７五歩打     (00:00/00:00:00)
# >>   60 ７三金(74)   (00:00/00:00:00)
# >>   61 ４六歩(47)   (00:00/00:00:00)
# >>   62 ４六歩(45)   (00:00/00:00:00)
# >>   63 ４六銀(57)   (00:00/00:00:00)
# >>   64 ４五歩打     (00:00/00:00:00)
# >>   65 ５七銀(46)   (00:00/00:00:00)
# >>   66 ６三金(73)   (00:00/00:00:00)
# >>   67 ３八飛(28)   (00:00/00:00:00)
# >>   68 ４一飛(51)   (00:00/00:00:00)
# >>   69 ２八飛(38)   (00:00/00:00:00)
# >>   70 ４三飛(41)   (00:00/00:00:00)
# >>   71 ８六歩(87)   (00:00/00:00:00)
# >>   72 ８六歩(85)   (00:00/00:00:00)
# >>   73 ８六金(76)   (00:00/00:00:00)
# >>   74 ４二飛(43)   (00:00/00:00:00)
# >>   75 ８七玉(78)   (00:00/00:00:00)
# >>   76 ８二飛(42)   (00:00/00:00:00)
# >>   77 ８五歩打     (00:00/00:00:00)
# >>   78 ４二角(33)   (00:00/00:00:00)
# >>   79 ７六金(67)   (00:00/00:00:00)
# >>   80 ６七歩打     (00:00/00:00:00)
# >> *△手筋：垂れ歩
# >>   81 ９六玉(87)   (00:00/00:00:00)
# >> *▲囲い：四段端玉
# >>   82 ５一角(42)   (00:00/00:00:00)
# >>   83 ８八角(79)   (00:00/00:00:00)
# >>   84 ３三銀(44)   (00:00/00:00:00)
# >>   85 ５五歩(56)   (00:00/00:00:00)
# >>   86 ４六歩(45)   (00:00/00:00:00)
# >>   87 ４六銀(57)   (00:00/00:00:00)
# >>   88 ４二飛(82)   (00:00/00:00:00)
# >>   89 ４七歩打     (00:00/00:00:00)
# >>   90 ９四歩(93)   (00:00/00:00:00)
# >>   91 ９四歩(95)   (00:00/00:00:00)
# >>   92 ４五銀(34)   (00:00/00:00:00)
# >>   93 ４五銀(46)   (00:00/00:00:00)
# >>   94 ４五飛(42)   (00:00/00:00:00)
# >>   95 ４六銀打     (00:00/00:00:00)
# >>   96 ４三飛(45)   (00:00/00:00:00)
# >>   97 ２四歩(25)   (00:00/00:00:00)
# >>   98 ２四歩(23)   (00:00/00:00:00)
# >>   99 ６四歩(65)   (00:00/00:00:00)
# >>  100 ６四金(63)   (00:00/00:00:00)
# >>  101 ８四歩(85)   (00:00/00:00:00)
# >>  102 ８四角(51)   (00:00/00:00:00)
# >>  103 ５四歩(55)   (00:00/00:00:00)
# >>  104 ９五歩打     (00:00/00:00:00)
# >>  105 ８七玉(96)   (00:00/00:00:00)
# >>  106 ５四金(64)   (00:00/00:00:00)
# >>  107 ６五銀(66)   (00:00/00:00:00)
# >>  108 ４四金(54)   (00:00/00:00:00)
# >>  109 ８五桂(77)   (00:00/00:00:00)
# >>  110 ５五歩打     (00:00/00:00:00)
# >>  111 ６九歩打     (00:00/00:00:00)
# >>  112 ５一角(84)   (00:00/00:00:00)
# >>  113 ８四歩打     (00:00/00:00:00)
# >> *▲手筋：垂れ歩
# >>  114 ８四角(51)   (00:00/00:00:00)
# >>  115 ２五歩打     (00:00/00:00:00)
# >>  116 ５一角(84)   (00:00/00:00:00)
# >>  117 ２四歩(25)   (00:00/00:00:00)
# >>  118 ８四歩打     (00:00/00:00:00)
# >>  119 ９三桂成(85) (00:00/00:00:00)
# >>  120 ７三桂(81)   (00:00/00:00:00)
# >>  121 ７四銀(65)   (00:00/00:00:00)
# >>  122 ８五桂(73)   (00:00/00:00:00)
# >>  123 ８三圭(93)   (00:00/00:00:00)
# >>  124 ７七歩打     (00:00/00:00:00)
# >> *△手筋：垂れ歩
# >>  125 ９五金(86)   (00:00/00:00:00)
# >>  126 ２七歩打     (00:00/00:00:00)
# >>  127 １八飛(28)   (00:00/00:00:00)
# >>  128 ４五金(44)   (00:00/00:00:00)
# >>  129 ５三歩打     (00:00/00:00:00)
# >> *▲手筋：垂れ歩
# >>  130 ４六金(45)   (00:00/00:00:00)
# >>  131 ５二歩成(53) (00:00/00:00:00)
# >>  132 ５六金(46)   (00:00/00:00:00)
# >>  133 ９六玉(87)   (00:00/00:00:00)
# >>  134 ７八歩成(77) (00:00/00:00:00)
# >>  135 ８五金(95)   (00:00/00:00:00)
# >>  136 ８八と(78)   (00:00/00:00:00)
# >>  137 ９五玉(96)   (00:00/00:00:00)
# >>  138 ８五歩(84)   (00:00/00:00:00)
# >>  139 ５一と(52)   (00:00/00:00:00)
# >>  140 ８七と(88)   (00:00/00:00:00)
# >>  141 ８四玉(95)   (00:00/00:00:00)
# >>  142 ４七飛成(43) (00:00/00:00:00)
# >>  143 ７三角打     (00:00/00:00:00)
# >>  144 ２八銀打     (00:00/00:00:00)
# >> *△手筋：桂頭の銀
# >>  145 ９一角成(73) (00:00/00:00:00)
# >>  146 ２九銀(28)   (00:00/00:00:00)
# >>  147 ６五銀(74)   (00:00/00:00:00)
# >>  148 １八銀(29)   (00:00/00:00:00)
# >>  149 １八香(19)   (00:00/00:00:00)
# >>  150 ４四龍(47)   (00:00/00:00:00)
# >>  151 ９三玉(84)   (00:00/00:00:00)
# >>  152 ４六金(56)   (00:00/00:00:00)
# >>  153 ２六香打     (00:00/00:00:00)
# >>  154 ３四銀打     (00:00/00:00:00)
# >>  155 ２三桂打     (00:00/00:00:00)
# >>  156 ２八歩成(27) (00:00/00:00:00)
# >>  157 ３一桂成(23) (00:00/00:00:00)
# >>  158 ３一金(32)   (00:00/00:00:00)
# >>  159 ２三銀打     (00:00/00:00:00)
# >>  160 １三玉(22)   (00:00/00:00:00)
# >>  161 １五歩(16)   (00:00/00:00:00)
# >>  162 ２五歩打     (00:00/00:00:00)
# >>  163 ４五歩打     (00:00/00:00:00)
# >>  164 ４五金(46)   (00:00/00:00:00)
# >>  165 １四銀成(23) (00:00/00:00:00)
# >>  166 ２二玉(13)   (00:00/00:00:00)
# >>  167 ２五香(26)   (00:00/00:00:00)
# >>  168 １四香(11)   (00:00/00:00:00)
# >>  169 １四歩(15)   (00:00/00:00:00)
# >>  170 ２五銀(34)   (00:00/00:00:00)
# >>  171 ２三香打     (00:00/00:00:00)
# >>  172 ３二玉(22)   (00:00/00:00:00)
# >>  173 ２一香成(23) (00:00/00:00:00)
# >>  174 ２一金(31)   (00:00/00:00:00)
# >>  175 １三歩成(14) (00:00/00:00:00)
# >>  176 ２四銀(33)   (00:00/00:00:00)
# >>  177 ２三歩打     (00:00/00:00:00)
# >> *▲手筋：垂れ歩
# >>  178 １八と(28)   (00:00/00:00:00)
# >>  179 ２二歩成(23) (00:00/00:00:00)
# >>  180 ２二金(21)   (00:00/00:00:00)
# >>  181 ２二と(13)   (00:00/00:00:00)
# >>  182 ２二玉(32)   (00:00/00:00:00)
# >>  183 ５七桂打     (00:00/00:00:00)
# >>  184 １三玉(22)   (00:00/00:00:00)
# >>  185 投了         (00:00/00:00:00)
# >> まで184手で後手の勝ち
