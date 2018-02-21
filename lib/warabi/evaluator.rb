# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Evaluator
    attr_reader :player
    attr_reader :params

    def initialize(player, **params)
      @player = player
      @params = params
    end

    def score
      score = 0
      score += player_score_for(player)
      score -= player_score_for(player.opponent_player)
      score
    end

    def score2
      score = 0
      score += player_score_for(player)
      score -= player_score_for(player.opponent_player)

      count = player.mediator.position_map[player.mediator.position_hash]
      if count >= 1
        score -= 9999 * count
      end
      score
    end

    def score_debug
      rows = []
      rows += score_debug2(player)
      rows += score_debug2(player.opponent_player).collect { |e| e.merge(total: -e[:total]) }
      rows + [{total: rows.collect { |e| e[:total] }.sum }]
    end

    private

    def score_debug2(player)
      rows = player.soldiers.group_by(&:itself).transform_values(&:size).collect { |soldier, count|
        if soldier.promoted
          weight = soldier.piece.promoted_weight
        else
          weight = soldier.piece.basic_weight
        end
        {piece: soldier, count: count, weight: weight, total: weight * count}
      }
      rows + player.piece_box.score_debug
    end

    def player_score_for(player)
      score = 0

      score += player.soldiers.collect { |e|
        if e.promoted
          e.piece.promoted_weight
        else
          e.piece.basic_weight
        end
      }.sum

      score += player.piece_box.score

      score
    end
  end
end
