# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  # 形勢判断
  class Evaluate
    Maximum = 22284              # 最大値は適当

    def initialize(player)
      @player = player
    end

    # 自分の駒が良い状態なのは自分がプラスになり、相手の形勢が良いときは自分にとってマイナスになる
    def evaluate
      evaluate_for(@player) - evaluate_for(@player.reverse_player)
    end

    def evaluate_for(player)
      score = 0

      # 盤上の駒
      score += player.soldiers.collect{|soldier|
        if soldier.promoted?
          {pawn: 1200, bishop: 2000, rook: 2200, lance: 1200, knight: 1200, silver: 1200}[soldier.piece.sym_name]
        else
          {pawn: 100, bishop: 1800, rook: 2000, lance: 600, knight: 700, silver: 1000, gold: 1200, king: 9999}[soldier.piece.sym_name]
        end
      }.reduce(:+) || 0

      # 持駒
      score += player.pieces.collect{|piece|
        {pawn: 105, bishop: 1890, rook: 2100, lance: 630, knight: 735, silver: 1050, gold: 1260, king: 9999}[piece.sym_name]
      }.reduce(:+) || 0

      score
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
  end
end
