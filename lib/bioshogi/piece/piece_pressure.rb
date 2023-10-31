# frozen-string-literal: true

module Bioshogi
  class Piece
    class PiecePressure
      include ApplicationMemoryRecord
      memory_record [
        { key: :king,   attack_level: 4, promoted_attack_level: nil, defense_level: 0, promoted_defense_level:   0, standby_level: 0, },
        { key: :rook,   attack_level: 4, promoted_attack_level: 5,   defense_level: 1, promoted_defense_level:   1, standby_level: 3, },
        { key: :bishop, attack_level: 3, promoted_attack_level: 4,   defense_level: 0, promoted_defense_level:   2, standby_level: 2, },
        { key: :gold,   attack_level: 3, promoted_attack_level: nil, defense_level: 1, promoted_defense_level: nil, standby_level: 2, },
        { key: :silver, attack_level: 3, promoted_attack_level: 3,   defense_level: 1, promoted_defense_level:   1, standby_level: 2, },
        { key: :knight, attack_level: 2, promoted_attack_level: 3,   defense_level: 0, promoted_defense_level:   1, standby_level: 1, },
        { key: :lance,  attack_level: 1, promoted_attack_level: 3,   defense_level: 0, promoted_defense_level:   1, standby_level: 1, },
        { key: :pawn,   attack_level: 1, promoted_attack_level: 3,   defense_level: 0, promoted_defense_level:   1, standby_level: 0, },
      ]

      def piece
        Piece.fetch(key)
      end
    end
  end
end
