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
    def score
      player_score_for(@player) - player_score_for(@player.flip_player)
    end

    #       |----------| ← この部分の幅をパーセンテージで返す
    # -1500 [==][======] +1500
    #    +0 [====][====] 0
    # +1500 [======][==] -1500
    # +3000 [========][] -3000
    def score_percentage(max = Maximum)
      half = 100.0 / Location.count
      v = half + (score.to_f / max * half)
      [0, [100.0, v.round].min].max
    end

    private

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

      score += player.piece_box.score

      score
    end
  end
end

