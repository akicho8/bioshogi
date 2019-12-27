# frozen-string-literal: true

require "bioshogi/evaluator/base"

module Bioshogi
  module Evaluator
    # 評価すること
    # ・盤上の駒の価値
    class Level1 < Base
      private

      def total_score(player)
        w = 0
        w += player.piece_box.score
        w += player.soldiers.sum { |e| soldier_score(e) }
        w
      end

      # 自分基準評価値
      def soldier_score(e)
        e.abs_weight
      end
    end
  end
end
