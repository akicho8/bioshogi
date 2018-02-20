# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Evaluator
    attr_reader :player

    def initialize(player)
      @player = player
    end

    def score
      player_score_for(player) - player_score_for(player.opponent_player)
    end

    private

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
