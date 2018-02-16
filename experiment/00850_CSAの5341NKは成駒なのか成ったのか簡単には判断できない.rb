require "./example_helper"

# 5341NK だけでは判断が難しい例

mediator = Mediator.new
mediator.board.set_from_preset_key
mediator.execute("７六歩")
mediator.execute("３四歩")
mediator.execute("７七桂")
mediator.execute("８四歩")
mediator.execute("６五桂")
mediator.execute("３二金")
mediator.execute("５三桂")
mediator.execute("８五歩")
mediator.execute("5341NK") # 元位置の 53 の地点の駒を調べてもらい、成っていないのであれば NK は「４一桂成」で、成っていれば「４一成銀」になる
puts mediator
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉 圭v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・v金v角 ・|二
# >> |v歩 ・v歩v歩 ・v歩 ・v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・v歩 ・ ・|四
# >> | ・v歩 ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 ・ 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：歩
# >> 手数＝9 ▲４一桂成(53) まで
# >> 
# >> 後手番
