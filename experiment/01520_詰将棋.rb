require "./setup"

xcontainer = Xcontainer.new
xcontainer.board.placement_from_shape(<<~EOT)
+---+
|v玉|
| ・|
| ・|
+---+
EOT
xcontainer.player_at(:black).pieces_set("★竜") # 必要なものだけ拾うのでエラーにはならない
xcontainer.player_at(:black).pieces_set("飛　金0銀1銀2")
xcontainer.player_at(:white).pieces_set("香2")
puts xcontainer
# >> 後手の持駒：香二
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：飛 金 銀三
# >> 手数＝0 まで
# >> 
# >> 先手番
