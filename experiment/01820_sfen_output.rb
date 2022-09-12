require "./setup"

xcontainer = Xcontainer.new
xcontainer.placement_from_preset("平手")
xcontainer.before_run_process
xcontainer.to_history_sfen                # => "position startpos"
xcontainer.pieces_set("▲銀△銀銀")
puts xcontainer
xcontainer.board.to_sfen          # => "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL"
xcontainer.to_history_sfen                # => "position startpos"
xcontainer.execute("▲６八銀")
xcontainer.hand_logs.last.to_sfen # => "7i6h"
xcontainer.to_history_sfen                # => "position startpos moves 7i6h"
xcontainer.execute("△２四銀打")
xcontainer.hand_logs.last.to_sfen # => "S*2d"
xcontainer.to_history_sfen                # => "position startpos moves 7i6h S*2d"
xcontainer.initial_state_board_sfen # => "startpos"
puts xcontainer.board
xcontainer.to_short_sfen        # => "sfen lnsgkgsnl/1r5b1/ppppppppp/7s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b Ss 3"
xcontainer.hand_logs.collect(&:to_sfen) # => ["7i6h", "S*2d"]

xcontainer.execute("▲52銀打")
xcontainer.execute("△94歩")
xcontainer.execute("▲43銀成")
xcontainer.to_short_sfen        # => "sfen lnsgkgsnl/1r5b1/1pppp+Sppp/p6s1/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w Ps 6"

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
