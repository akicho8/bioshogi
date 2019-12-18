# frozen-string-literal: true

require "bioshogi/evaluator/base"
require "bioshogi/evaluator/opening_basic_table"

module Bioshogi
  module Evaluator
    class Level2 < Base
      private

      # 評価すること
      # ・盤上の駒の価値
      # ・序盤で歩をつく
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

        w
      end
    end
  end
end
