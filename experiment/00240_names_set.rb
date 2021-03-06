require "./example_helper"

info = Parser.parse("position sfen 4k4/9/9/9/9/9/PPPPPPPPP/9/4K4 w - 1")
info.names_set(black: "alice", white: "bob")
puts info.to_ki2

info = Parser.parse("position startpos")
info.names_set(black: "alice", white: "bob")
puts info.to_ki2
# >> 上手：bob
# >> 下手：alice
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
# >> 
# >> まで0手で下手の勝ち
# >> 先手：alice
# >> 後手：bob
# >> 手合割：平手
# >> 
# >> まで0手で後手の勝ち
