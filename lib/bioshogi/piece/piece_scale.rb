# frozen-string-literal: true

module Bioshogi
  class Piece
    class PieceScale
      include ApplicationMemoryRecord
      memory_record [
        { key: :king,   scale: 1.00, },
        { key: :rook,   scale: 1.00, },
        { key: :bishop, scale: 1.00, },
        { key: :gold,   scale: 0.97, },
        { key: :silver, scale: 0.94, },
        { key: :knight, scale: 0.91, },
        { key: :lance,  scale: 0.88, },
        { key: :pawn,   scale: 0.85, },
      ]
    end
  end
end
