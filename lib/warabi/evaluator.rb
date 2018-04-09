# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Evaluator
    attr_reader :player
    attr_reader :params

    delegate :mediator, :board, to: :player

    def initialize(player, **params)
      @player = player
      @params = params
    end

    def score
      basic_score * player.location.value_sign
    end

    # これ使ってない？
    def score3
      score = player_score_for
      count = player.mediator.one_place_map[player.mediator.one_place_hash]
      if count >= 1
        score -= 9999 * count
      end
      score
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

    def detail_score
      rows = []
      rows += detail_score_for(player)
      rows += detail_score_for(player.opponent_player).collect { |e| e.merge(total: -e[:total]) }
      rows + [{total: rows.collect { |e| e[:total] }.sum }]
    end

    private

    def soldier_score(e)
      w = e.piece.any_weight(e.promoted)
      key = [e.piece.key, e.promoted].join("_")
      if v = BoardPlaceScore[key]
        place = e.place.flip_if_white(e.location) # ▲側からの座標に補正
        y = place.y.value
        x = place.x.value
        s = v.score_fields[y][x]
        w += s
      end
      w * e.location.value_sign
    end

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
