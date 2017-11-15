# 棋譜の入力
require_relative "example_helper"

mediator = Mediator.start
mediator.piece_plot
mediator.execute("7六歩")
mediator.execute("3四歩")
mediator.execute("2二角成")
mediator.player_at(:black).to_s_pieces # => "角"
puts mediator.board
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・ 馬 ・|二
# >> |v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・v歩 ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
