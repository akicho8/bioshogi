# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  # 形勢判断
  class Evaluator
    Maximum = 22284              # 最大値は適当

    def initialize(player)
      @player = player
    end

    # 自分の駒が良い状態なのは自分がプラスになり、相手の形勢が良いときは自分にとってマイナスになる
    def evaluate
      player_score_for(@player) - player_score_for(@player.reverse_player)
    end

    #       |----------| ← この部分の幅をパーセンテージで返す
    # -1500 [==][======] +1500
    #    +0 [====][====] 0
    # +1500 [======][==] -1500
    # +3000 [========][] -3000
    def score_percentage(max = Maximum)
      half = 100.0 / @player.mediator.players.size
      v = half + (evaluate.to_f / max * half)
      [0, [100.0, v.round].min].max
    end

    private

    # def evaluate_pair
    #   [evaluate_self, evaluate_reverse]
    # end
    #
    # # 自分側の状態だけを考慮して取得
    # def evaluate_self
    #   player_score_for(@player)
    # end
    #
    # # 相手側の状態だけを考慮して取得
    # def evaluate_reverse
    #   player_score_for(@player.reverse_player)
    # end

    def player_score_for(player)
      score = 0

      # 盤上の駒
      score += player.soldiers.collect { |e|
        if e.promoted
          e.piece.promoted_weight
        else
          e.piece.basic_weight
        end
      }.sum

      # 持駒
      score += player.pieces.collect { |e|
        e.hold_weight
      }.sum

      score
    end
  end
end

