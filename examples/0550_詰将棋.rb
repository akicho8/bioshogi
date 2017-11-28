require "./example_helper"

mediator = Mediator.new
mediator.board_reset_for_text(<<~EOT)
+---+
|v玉|
| ・|
| ・|
+---+
EOT
mediator.player_at(:black).pieces_set("竜") # エラーにならない……？

mediator.player_at(:black).pieces_set("飛　金0銀1銀2")
mediator.player_at(:white).pieces_set("香123")
puts mediator
# >> 1手目: ▲先手番
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
# >> ▲先手の持駒:飛 銀三
# >> ▽後手の持駒:香一二三
