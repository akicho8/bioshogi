require "./example_helper"

info = Parser.parse(<<~EOT)
後手の持駒：
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・v金 ・v飛 ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ ・ ・ ・ ・ ・|九
+---------------------------+
先手の持駒：銀
手数----指手---------消費時間--
   1 51銀
EOT
puts info.to_kif
# >> {:piece_key=>:pawn, :promoted=>false, :motion=>:drop}
# >> {:piece_key=>:knight, :promoted=>false, :motion=>:move}
# >> {:piece_key=>:silver, :promoted=>false, :motion=>:both}
# >> {:piece_key=>:pawn, :promoted=>false, :motion=>:drop}
# >> {:piece_key=>:bishop, :promoted=>false, :motion=>:drop}
# >> {:piece_key=>:silver, :promoted=>false, :motion=>:drop}
# >> {:piece_key=>:silver, :promoted=>false, :motion=>:both}
# >> 先手の手筋：割り打ちの銀
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|一
# >> | ・ ・ ・v金 ・v飛 ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：銀
# >> 手数----指手---------消費時間--
# >>    1 ５一銀打     (00:00/00:00:00)
# >> *▲手筋：割り打ちの銀
# >>    2 投了
# >> まで1手で先手の勝ち
