require "./setup"

info = Parser.parse(<<~EOT)
後手の持駒：金9香9飛9
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v玉 ・ ・ ・ ・ ・ ・ ・ ・|一
|v金v金v金v金v金v金v金v金v金|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・v飛 飛v飛 飛v飛 飛v飛 飛|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| 香 金 金 金 金 金 金 金 金|八
| ・ 龍 ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
先手の持駒：金9香9飛9
手数----指手---------消費時間--
   1 14香打
   2 26香打
   3 13香打
   4 27香打
   5 34飛打
   6 46飛打
   7 56香打
   8 64香打
   9 99龍
EOT
puts info.to_kif
# >> 先手の手筋：3段ロケット
# >> 後手の手筋：3段ロケット
# >> 先手の備考：ロケット
# >> 後手の備考：ロケット
# >> 後手の持駒：飛九 金九 香九
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v玉 ・ ・ ・ ・ ・ ・ ・ ・|一
# >> |v金v金v金v金v金v金v金v金v金|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・v飛 飛v飛 飛v飛 飛v飛 飛|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | 香 金 金 金 金 金 金 金 金|八
# >> | ・ 龍 ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：飛九 金九 香九
# >> 先手番
# >> 手数----指手---------消費時間--
# >>    1 １四香打
# >> *▲手筋：2段ロケット
# >> *▲備考：ロケット
# >>    2 ２六香打
# >> *△手筋：2段ロケット
# >> *△備考：ロケット
# >>    3 １三香打
# >> *▲手筋：3段ロケット
# >> *▲備考：ロケット
# >>    4 ２七香打
# >> *△手筋：3段ロケット
# >> *△備考：ロケット
# >>    5 ３四飛打
# >>    6 ４六飛打
# >>    7 ５六香打
# >>    8 ６四香打
# >>    9 ９九龍(89)
# >> *▲手筋：2段ロケット
# >> *▲備考：ロケット
# >>   10 投了
# >> まで9手で先手の勝ち
