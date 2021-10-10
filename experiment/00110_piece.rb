require "./setup"

Piece.s_to_h("飛0 角 竜1 馬2 龍2")                    # => {:rook=>3, :bishop=>3}
Piece.h_to_a(rook: 2, bishop: 1).collect(&:name)      # => ["飛", "飛", "角"]
Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
Piece.a_to_s([:bishop, "竜", "竜"])                   # => "飛二 角"
Piece.s_to_h2("▲歩2 飛 △歩二飛 ▲金")               # => {:black=>{:pawn=>2, :rook=>1, :gold=>1}, :white=>{:pawn=>2, :rook=>1}}
Piece.h_to_s(bishop: 1, rook: 2)                      # => "飛二 角"

Piece.s_to_h("歩")       # => {:pawn=>1}
Piece.s_to_h("歩〇")     # => {:pawn=>0}
Piece.s_to_h("歩一")     # => {:pawn=>1}
Piece.s_to_h("歩十〇")   # => {:pawn=>10}
Piece.s_to_h("歩十")     # => {:pawn=>10}
Piece.s_to_h("歩十一")   # => {:pawn=>11}
Piece.s_to_h("歩二十一") # => {:pawn=>21}

tp Piece["飛"].to_h
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
# >> |                     stronger | true |
# >> |                         code | 1    |
# >> |------------------------------+------|
