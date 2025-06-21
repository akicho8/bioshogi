require "#{__dir__}/setup"

Piece.s_to_h("飛0 角 竜1 馬2 龍2")                    # => {:rook=>3, :bishop=>3}
Piece.h_to_a(rook: 2, bishop: 1).collect(&:name)      # => ["飛", "飛", "角"]
Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
Piece.a_to_s([:bishop, "竜", "竜"])                   # => "飛二 角"
Piece.a_to_h([:bishop, "竜", "竜"])                   # => {:bishop=>1, :rook=>2}
Piece.s_to_h2("▲歩2 飛 △歩二飛 ▲金")               # => {:black=>{:pawn=>2, :rook=>1, :gold=>1}, :white=>{:pawn=>2, :rook=>1}}
Piece.h_to_s(bishop: 1, rook: 2)                      # => "飛二 角"

Piece.s_to_h("歩")       # => {:pawn=>1}
Piece.s_to_h("歩〇")     # => {:pawn=>0}
Piece.s_to_h("歩一")     # => {:pawn=>1}
Piece.s_to_h("歩十〇")   # => {:pawn=>10}
Piece.s_to_h("歩十")     # => {:pawn=>10}
Piece.s_to_h("歩十一")   # => {:pawn=>11}
Piece.s_to_h("歩二十一") # => {:pawn=>21}

tp Piece.strong_pieces          # => [<Bioshogi::Piece:2000 飛 rook>, <Bioshogi::Piece:2020 角 bishop>]

tp Piece["飛"].to_h
# >> |----|
# >> | 飛 |
# >> | 角 |
# >> |----|
# >> |------------------------------+------|
# >> |                          key | rook |
# >> |                         name | 飛   |
# >> |                  basic_alias |      |
# >> |                promoted_name | 龍   |
# >> |   promoted_formal_sheet_name |      |
# >> | other_matched_promoted_names | 竜   |
# >> |                    sfen_char | R    |
# >> |                   promotable | true |
# >> |                 always_alive | true |
# >> |                       strong | true |
# >> |               dengaku_target | true |
# >> |              tatakare_target | true |
# >> |                  forward_movable | true |
# >> |                         code | 1    |
# >> |------------------------------+------|
