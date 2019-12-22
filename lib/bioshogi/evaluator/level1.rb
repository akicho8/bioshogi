# frozen-string-literal: true

require "bioshogi/evaluator/base"

module Bioshogi
  module Evaluator
    # 評価すること
    # ・盤上の駒の価値
    class Level1 < Base
      private

      # 自分基準評価値
      def score_compute
        w = 0
        board.surface.each_value do |e|
          w += soldier_score(e) * e.location.value_sign
        end
        players.each do |e|
          w += e.piece_box.score * e.location.value_sign
        end
        w * player.location.value_sign
      end

      # 自分基準評価値
      def soldier_score(e)
        e.abs_weight
      end
    end
  end
end
