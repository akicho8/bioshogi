require "../setup"

sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8h2b+"
Parser.parse(sfen).to_sfen rescue $! # => #<Bioshogi::CandidateSoldiersNotInclude: 【反則】▲２二角成(88)としましたが８八から２二には移動できません
Parser.parse(sfen, validate_warp_skip: true).to_sfen # => "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8h2b+"

