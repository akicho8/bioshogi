require "./example_helper"

mediator = Mediator.new

mediator.board.all_clear
mediator.board.placement_from_hash(black: "十枚落ち", white: "裸玉")
mediator.turn_info.handicap = true # △から始める場合
mediator.to_long_sfen # => "sfen 4k4/9/9/9/9/9/PPPPPPPPP/9/4K4 w - 1"
puts mediator

# >> 上手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
# >> +---------------------------+
# >> 下手の持駒：なし
# >> 手数＝0 まで
# >> 
# >> 上手番
