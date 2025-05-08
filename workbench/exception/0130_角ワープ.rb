require "../setup"

sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8h2b+"
Parser.parse(sfen).to_sfen rescue $! # => #<Bioshogi::SoldierWarpError:"【反則】▲２二角成(88)としましたが８八から２二には移動できません\n手番: 先手\n指し手: 8h2b+\n棋譜:\n\n後手の持駒：なし\n  ９ ８ ７ ６ ５ ４ ３ ２ １\n+---------------------------+\n|v香v桂v銀v金v玉v金v銀v桂v香|一\n| ・v飛 ・ ・ ・ ・ ・v角 ・|二\n|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|四\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|五\n| ・ ・ ・ ・ ・ ・ ・ ・ ・|六\n| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七\n| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八\n| 香 桂 銀 金 玉 金 銀 桂 香|九\n+---------------------------+\n先手の持駒：なし\n手数＝0 まで\n先手番">
Parser.parse(sfen, warp_detect: false).to_sfen # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8h2b+"
