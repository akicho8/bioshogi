# 棋譜の入力とkif形式のログ確認
require_relative "example_helper"

mediator = Mediator.start
mediator.piece_plot
[
  "７六歩", "８四歩", "７八金", "３二金",
].each{|input|
  mediator.execute(input)
}
puts mediator.board
pp mediator.kif_hand_logs
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉 ・v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・v金v角 ・|二
# >> |v歩 ・v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・v歩 ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 金 ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 ・ 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> ["▲7六歩(77)", "▽8四歩(83)", "▲7八金(69)", "▽3二金(41)"]
