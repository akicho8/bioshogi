require "./setup"

mediator = Mediator.new
mediator.board.hash
mediator.board.placement_from_hash(black: "裸玉", white: "裸玉")
mediator.pieces_set("▲飛 △飛")
mediator.one_place_hash # => 2648218993557200246
mediator.execute("▲５八玉")
mediator.execute("△５二玉")
mediator.one_place_hash # => -284929841389289087
mediator.execute("▲５九玉")
mediator.execute("△５一玉")
mediator.one_place_hash # => 2648218993557200246
mediator.one_place_map      # => {}
puts mediator
# >> 後手の持駒：飛
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# >> | ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
# >> +---------------------------+
# >> 先手の持駒：飛
# >> 手数＝4 △５一玉(52) まで
# >> 
# >> 先手番
