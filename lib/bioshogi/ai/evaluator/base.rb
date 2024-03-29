# frozen-string-literal: true

module Bioshogi
  module AI
    module Evaluator
      class Base
        attr_reader :player
        attr_reader :params

        delegate :container, :board, to: :player
        delegate :players, to: :container

        def self.default_params
          {}
        end

        def initialize(player, params = {})
          @player = player
          @params = self.class.default_params.merge(params)
        end

        # 自分基準評価値
        def score
          Bioshogi.run_counts["#{self.class.name}#score"] += 1
          score_compute
        end

        private

        def score_compute
          (total_score(player) - total_score(player.op)).to_i
        end

        def total_score(player)
          0
        end
      end
    end
  end
end
