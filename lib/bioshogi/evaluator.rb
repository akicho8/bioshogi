# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
  class EvaluatorBase
    attr_reader :player
    attr_reader :params

    delegate :mediator, :board, to: :player

    def self.default_params
      {}
    end

    def initialize(player, **params)
      @player = player
      @params = self.class.default_params.merge(params)
    end

    def score
      Bioshogi.run_counts["#{self.class.name}#score"] += 1
      basic_score * player.location.value_sign
    end

    # ▲から見た評価値
    def basic_score
      score = 0
      board.surface.each_value do |e|
        score += soldier_score(e)
      end
      mediator.players.each do |e|
        score += e.piece_box.score * e.location.value_sign
      end
      score
    end

    private

    def soldier_score(e)
      e.relative_weight
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

  class EvaluatorAdvance < EvaluatorBase
    private

    def soldier_score(e)
      w = e.relative_weight

      if !e.promoted
        if t = score_table[:field][e.piece.key]
          x, y = e.normalized_place.to_xy
          w += t[y][x]
        end
        if t = score_table[:advance][e.piece.key]
          s = t[e.bottom_spaces]
          w += s
        end
      end

      w * e.location.value_sign
    end

    def score_table
      EvaluatorAdvanceScoreTable
    end
  end
end
