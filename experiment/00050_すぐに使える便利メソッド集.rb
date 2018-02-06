require "./example_helper"

Piece.s_to_h("飛0 角 竜1 馬2 龍2")                                                 # => {:rook=>3, :bishop=>3}
Piece.h_to_a(rook: 3, "角" => 3, "飛" => 1).collect(&:name)                        # => ["飛", "飛", "飛", "角", "角", "角", "飛"]
Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name)                              # => ["飛", "飛", "飛", "飛", "角", "角", "角"]
Piece.a_to_s(["竜", :pawn, "竜"], ordered: true, separator: "/")                   # => "飛二/歩"
Piece.s_to_a2("▲歩2 飛 △歩二飛 ▲金").transform_values { |e| e.collect(&:name) } # => {:black=>["歩", "歩", "飛", "金"], :white=>["歩", "歩", "飛"]}
