# frozen-string-literal: true

module Bioshogi
  class Piece
    class PieceScore
      include ApplicationMemoryRecord
      memory_record [
        { key: :king,   basic_weight: 40000, promoted_weight: 0,    hold_weight: 40000, },
        { key: :rook,   basic_weight:  2000, promoted_weight: 2200, hold_weight:  2100, },
        { key: :bishop, basic_weight:  1800, promoted_weight: 2000, hold_weight:  1890, },
        { key: :gold,   basic_weight:  1200, promoted_weight: 0,    hold_weight:  1260, },
        { key: :silver, basic_weight:  1000, promoted_weight: 1200, hold_weight:  1050, },
        { key: :knight, basic_weight:   700, promoted_weight: 1200, hold_weight:   735, },
        { key: :lance,  basic_weight:   600, promoted_weight: 1200, hold_weight:   630, },
        { key: :pawn,   basic_weight:   100, promoted_weight: 1200, hold_weight:   105, },
      ]

      class << self
        # このスコア以上であれば必勝(姿焼き判定)とする
        def sure_victory_score
          @sure_victory_score ||= [
            self[:king].basic_weight,      # 玉
            self[:rook].promoted_weight,   # 龍
            self[:bishop].promoted_weight, # 馬
            self[:rook].hold_weight,       # 飛 (持駒)
            self[:bishop].hold_weight,     # 角 (持駒)
            self[:gold].basic_weight * 4,  # 金相当 * 4 (と金などを含む)
          ].sum
        end
      end

      def piece
        Piece.fetch(key)
      end

      def any_weight(promoted)
        if promoted
          promoted_weight
        else
          basic_weight
        end
      end
    end
  end
end
