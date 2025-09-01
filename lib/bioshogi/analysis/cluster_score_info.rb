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
        {
          key: "駒得は正義の閾値",
          scores: [
            Piece[:rook].basic_weight * 1,   # 飛 (盤上)
            Piece[:bishop].basic_weight * 1, # 角 (盤上)
          ],
        },
        {
          key: "道場出禁の閾値",
          scores: [
            Piece[:rook].basic_weight * 1,   # 飛 (盤上)
            Piece[:bishop].basic_weight * 1, # 角 (盤上)
          ],
        },
      ]

      def min_score
        @min_score ||= scores.sum
      end
    end
  end
end
