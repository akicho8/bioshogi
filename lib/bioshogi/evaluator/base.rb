# frozen-string-literal: true

module Bioshogi
  module Evaluator
    class Base
      attr_reader :player
      attr_reader :params

      delegate :mediator, :board, to: :player
      delegate :players, to: :mediator

      def self.default_params
        {}
      end

      def initialize(player, **params)
        @player = player
        @params = self.class.default_params.merge(params)
      end

      # 自分基準評価値
      def score
        Bioshogi.run_counts["#{self.class.name}#score"] += 1
        score_compute
      end

      def score_compute
        0
      end

      concerning :DebugMethods do
        def detail_score
          rows = []
          rows += detail_score_for(player)
          rows += detail_score_for(player.opponent_player).collect { |e| e.merge(total: -e[:total]) }
          rows + [{total: rows.collect { |e| e[:total] }.sum }]
        end

        private

        def detail_score_for(player)
          rows = player.soldiers.group_by(&:itself).transform_values(&:size).collect { |soldier, count|
            if soldier.promoted
              weight = soldier.piece.promoted_weight
            else
              weight = soldier.piece.basic_weight
            end
            {piece: soldier, count: count, weight: weight, total: weight * count}
          }
          rows + player.piece_box.detail_score
        end
      end
    end
  end
end
