require "./example_helper"

v = Utils.hold_pieces_s_to_a("歩二飛飛角飛") # => [<Bushido::Piece:70302291699260 歩 pawn>, <Bushido::Piece:70302291699260 歩 pawn>, <Bushido::Piece:70302291699760 飛 rook>, <Bushido::Piece:70302291699760 飛 rook>, <Bushido::Piece:70302291699680 角 bishop>, <Bushido::Piece:70302291699760 飛 rook>]
Utils.hold_pieces_a_to_s(v, ordered: true, separator: "/") # => "飛三/角/歩二"
