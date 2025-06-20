require "#{__dir__}/setup"

container = Container::Basic.new
container.placement_from_preset("平手")
container.after_setup
container.to_history_sfen                # => "position startpos"
container.pieces_set("▲銀△銀銀")
puts container
container.board.to_sfen          # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
container.to_history_sfen                # => "position startpos"
container.execute("▲６八銀")
container.hand_logs.last.to_sfen # => "7i6h"
container.to_history_sfen                # => "position startpos moves 7i6h"
container.execute("△２四銀打")
container.hand_logs.last.to_sfen # => "S*2d"
container.to_history_sfen                # => "position startpos moves 7i6h S*2d"
container.initial_state_board_sfen # => "startpos"
puts container.board
container.to_short_sfen        # => "sfen lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
container.hand_logs.collect(&:to_sfen) # => ["7i6h", "S*2d"]

container.execute("▲52銀打")
container.execute("△94歩")
container.execute("▲43銀成")
container.to_short_sfen        # => "sfen lnsgkgsnl/1r5b1/1pppp+Sppp/p6s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w Ps 6"

# >> 後手の持駒：銀二
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
# >> 先手の持駒：銀
# >> 手数＝0 まで
# >>
# >> 先手番
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・v銀 ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
