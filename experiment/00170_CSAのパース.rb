require "./example_helper"

info = Parser.parse(<<~EOT)
V2.2
PI82HI22KA
+
+7968GI,T5
-3334FU
%TORYO,T16
EOT

Piece.fetch("HI")               # => 

puts info.to_csa
# ~> /Users/ikeda/src/bushido/lib/bushido/piece.rb:54:in `rescue in fetch': "HI" に対応する駒がありません (Bushido::PieceNotFound)
# ~> Bushido::Piece.fetch("HI") does not match anything
# ~> keys: [:king, :rook, :bishop, :gold, :silver, :knight, :lance, :pawn]
# ~> codes: [0, 1, 2, 3, 4, 5, 6, 7]
# ~> 	from /Users/ikeda/src/bushido/lib/bushido/piece.rb:51:in `fetch'
# ~> 	from -:12:in `<main>'
# >> #<MatchData "PI82HI22KA" komaochi_piece_list:"82HI22KA">
# >> #<Bushido::Point:70240268510900 "８二">
# >> #<Bushido::Point:70240268510180 "２二">
