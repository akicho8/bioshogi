require "./setup"
info = Parser.parse(<<~EOT)
後手の持駒：
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ 玉 ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| 香 ・ ・ ・ ・ ・ ・ ・ ・|
| 飛 ・ ・ ・ ・ ・ ・ ・ ・|
+---------------------------+
先手の持駒：飛

91飛
EOT
puts info.to_kif
# >> 先手の手筋：2段ロケット
# >> 先手の備考：ロケット
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ 玉 ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | 香 ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | 飛 ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：飛
# >> 先手番
# >> 手数----指手---------消費時間--
# >>    1 ９一飛打
# >> *▲手筋：2段ロケット
# >>    2 投了
# >> まで1手で先手の勝ち
