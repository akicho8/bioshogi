require "./example_helper"

piece = Piece[:pawn]
piece.any_weight(false)         # => 100
piece.any_weight(true)          # => 1200
