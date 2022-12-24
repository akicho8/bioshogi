# frozen-string-literal: true

module Bioshogi
  module Ai
    module Evaluator
      # 評価すること
      # ・盤上の駒の価値
      # ・詰将棋モードの場合はYの位置を考慮したら逆に面倒なことになるのでこの評価方法でよい
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
end
