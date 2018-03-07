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
      player.mediator.basic_score * player.location.value_sign
    end

    def score2
      score = player_score_for
      count = player.mediator.one_place_map[player.mediator.one_place_hash]
      if count >= 1
        score -= 9999 * count
      end
      score
    end

    def detail_score
      rows = []
      rows += detail_score2(player)
      rows += detail_score2(player.opponent_player).collect { |e| e.merge(total: -e[:total]) }
      rows + [{total: rows.collect { |e| e[:total] }.sum }]
    end

    private

    def detail_score2(player)
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
