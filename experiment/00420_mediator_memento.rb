require "./example_helper"

mediator = Mediator.start
mediator.pieces_set("▲歩")
mediator.execute("▲６八銀")
puts mediator
mediator.to_current_sfen   # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w P 2"

memento = mediator.create_memento
mediator.execute("△３四歩", executor_class: PlayerExecutorWithoutMonitor)
puts mediator
mediator.to_current_sfen   # => "sfen lnsgkgsnl/1r5b1/pppppp1pp/6p2/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL b P 3"

mediator.restore_memento(memento)
puts mediator
mediator.to_current_sfen   # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w P 2"

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
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：歩
# >> 手数＝1 ▲６八銀(79) まで
# >> 
# >> 後手番
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩 ・v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・v歩 ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：歩
# >> 手数＝2 ▲６八銀(79) まで
# >> 
# >> 先手番
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
# >> | ・ 角 ・ 銀 ・ ・ ・ 飛 ・|八
# >> | 香 桂 ・ 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：歩
# >> 手数＝1 ▲６八銀(79) まで
# >> 
# >> 後手番
