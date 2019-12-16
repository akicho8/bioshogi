require "./example_helper"

mediator = Mediator.new
mediator.player_at(:black).king_place # => nil
mediator.placement_from_preset("平手")
mediator.player_at(:black).king_place # => #<Bioshogi::Place ５九>
mediator.execute("58玉")
mediator.player_at(:black).king_place # => #<Bioshogi::Place ５八>
puts mediator
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ 玉 ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 ・ 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝1 ▲５八玉(59) まで
# >> 
# >> 後手番
