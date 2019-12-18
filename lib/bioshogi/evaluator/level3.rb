# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/opening_basic_table"
require "bioshogi/evaluator/attack_piece_weight_methods"

module Bioshogi
  module Evaluator
    class Level3 < Base
      include AttackPieceWeightMethods

      private

      # 評価すること
      # ・盤上の駒の価値
      # ・序盤で歩をつく
      # ・玉を追いつめる
      def soldier_score(e)
        w = e.abs_weight

        unless e.promoted
          if t = OpeningBasicTable[:field][e.piece.key]
            x, y = e.normalized_place.to_xy
            w += t[y][x]
          end
          if t = OpeningBasicTable[:advance][e.piece.key]
            s = t[e.bottom_spaces]
            w += s
          end
        end

        w += soldier_score_for_attack(e) || 0

        w
      end
    end
  end
end
