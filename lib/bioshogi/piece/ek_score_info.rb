# frozen-string-literal: true

module Bioshogi
  class Piece
    class EkScoreInfo
      include ApplicationMemoryRecord
      memory_record [
        # https://www.shogi.or.jp/faq/amature-kitei.html
        { key: :king,   ek_score: 0, },
        { key: :rook,   ek_score: 5, },
        { key: :bishop, ek_score: 5, },
        { key: :gold,   ek_score: 1, },
        { key: :silver, ek_score: 1, },
        { key: :knight, ek_score: 1, },
        { key: :lance,  ek_score: 1, },
        { key: :pawn,   ek_score: 1, },
      ]
    end
  end
end
