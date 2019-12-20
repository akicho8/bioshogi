# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/opening_basic_table"
require "bioshogi/evaluator/attack_piece_weight_methods"

module Bioshogi
  module Evaluator
    class Level3 < Base
      include AttackPieceWeightMethods

      def danger_level_at
        @danger_level_at ||= mediator.players.inject({}) { |a, e| a.merge(e.location => e.pressure_rate) }
      end

      private

      # 評価すること
      # ・盤上の駒の価値
      # ・序盤で歩をつく
      # ・玉を追いつめる
      def soldier_score(e)
        w = e.abs_weight

        w2 = 0
        unless e.promoted
          if t = OpeningBasicTable[:field][e.piece.key]
            x, y = e.normalized_place.to_xy
            w2 += t[y][x]
          end
          if t = OpeningBasicTable[:advance][e.piece.key]
            s = t[e.bottom_spaces]
            w2 += s
          end
        end

        w += w2
        w += (soldier_score_for_attack(e) || 0) * danger_level_at[e.location]

        w
      end

    end
  end
end
