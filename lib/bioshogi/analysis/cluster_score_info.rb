# frozen-string-literal: true

module Bioshogi
  module Analysis
    class ClusterScoreInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "圧倒的な駒得",
          scores: [
            Piece[:king].basic_weight,      # 玉
            Piece[:rook].promoted_weight,   # 龍
            Piece[:bishop].promoted_weight, # 馬
            Piece[:rook].hold_weight,       # 飛 (持駒)
            Piece[:bishop].hold_weight,     # 角 (持駒)
            Piece[:gold].basic_weight * 4,  # 金相当 * 4 (と金などを含む)
          ],
        },
        {
          key: "天空の城構成員",
          scores: [
            Piece[:gold].basic_weight,
            Piece[:silver].basic_weight * 2,
            Piece[:pawn].basic_weight,
          ],
        },
      ]

      def min_score
        @min_score ||= scores.sum
      end
    end
  end
end
