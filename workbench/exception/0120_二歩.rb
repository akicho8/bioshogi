require "../setup"

sfen = "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
Parser.parse(sfen).to_sfen rescue $! # => #<Bioshogi::DoublePawnCommonError: 【反則】二歩です。すでに▲５六歩があるため▲５五歩打ができません
Parser.parse(sfen, double_pawn_detect: false).to_sfen # => "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
