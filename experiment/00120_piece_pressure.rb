require "./example_helper"

piece = Piece[:pawn]
piece.any_level(false)         # => 1
piece.any_level(true)          # => 0
