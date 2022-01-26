require "./setup"

mediator = Mediator.new
mediator.board.hash
mediator.board.placement_from_preset("平手")
mediator.pieces_set("▲飛 △飛")
mediator.one_place_hash # => 4440883322357192303
mediator.execute("▲５八玉")
mediator.execute("△５二玉")
mediator.one_place_hash # => 2468075424501378097
mediator.execute("▲５九玉")
mediator.execute("△５一玉")
mediator.one_place_hash # => 4440883322357192303
mediator.one_place_map      # => {}
puts mediator
# >> 後手の持駒：飛
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：飛
# >> 手数＝4 △５一玉(52) まで
# >> 
# >> 先手番
