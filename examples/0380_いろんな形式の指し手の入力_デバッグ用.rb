require "./example_helper"

mediator = Mediator.new
mediator.board_reset
mediator.execute("0076FU")
pp mediator.hand_logs.last
# >> #<Bushido::HandLog:0x007fdb8c28f6d0
# >>  @candidate=
# >>   [<Bushido::Soldier:70290463042220 @player=#<Bushido::Player:0x007fdb8c154e78> @piece=歩 ▲７七歩>],
# >>  @origin_point=#<Bushido::Point:70290459096780 "７七">,
# >>  @piece=<Bushido::Piece:70290462978720 歩 pawn>,
# >>  @player=
# >>   ----------------------------------------
# >> #<Bushido::Player:0x007fdb8c154e78 ...>
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> ▲先手の持駒:
# >> 
# >> ----------------------------------------,
# >>  @point=#<Bushido::Point:70290460484560 "７六">,
# >>  @point_same_p=nil,
# >>  @promote_trigger=false,
# >>  @promoted=nil,
# >>  @strike_trigger=false>
