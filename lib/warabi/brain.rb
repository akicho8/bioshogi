# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Brain
    attr_accessor :player

    def initialize(player)
      @player = player
    end

    def nega_max_run(params = {})
      nega_max_runner = NegaMaxRunner.new(params)
      nega_max_runner.nega_max(player: player)
    end

    def all_hands
      [*move_hands, *direct_hands]
    end

    def best_hand
      if v = score_list.first
        v[:hand]
      end
    end

    def score_list
      list = []
      all_hands.each do |hand|
        m = player.mediator.deep_dup
        _player = m.player_at(player.location)
        _player.execute(hand.to_sfen)
        list << {hand: hand, score: _player.evaluator.score}
      end
      list.sort_by { |e| -e[:score] }
    end

    # 盤上の駒の全手筋
    def move_hands
      Enumerator.new do |y|
        player.soldiers.each do |soldier|
          soldier.move_list(player.board).each do |move_hand|
            y << move_hand
          end
        end
      end
    end

    # 持駒の全打筋
    def direct_hands
      Enumerator.new do |y|
        player.board.blank_points.each do |point|
          player.piece_box.each_key do |piece_key|
            soldier = Soldier.create(piece: Piece[piece_key], promoted: false, point: point, location: player.location)
            if soldier.rule_valid?(player.board)
              y << DirectHand.create(soldier: soldier)
            end
          end
        end
      end
    end
  end

  class HandInfo < Hash
    def to_s
      "%s %+5d" % [self[:hand], self[:score]]
    end

    def to_s_short
      "#{self[:hand]}(#{self[:score]})"
    end
  end

  class NegaMaxRunner
    attr_accessor :params
    attr_accessor :eval_count

    def initialize(params)
      @params = {
        random: false,
        depth_max: 0,           # 最大の深さ
      }.merge(params)

      @eval_count = 0
    end

    def nega_max(locals = {})
      locals = {
        depth: 0,               # 現在の深さ
      }.merge(locals)

      logs = []

      player = locals[:player]

      mediator = player.mediator

      all_hands = player.brain.all_hands

      ary = []
      all_hands.each.with_index do |hand, i|
        m = mediator.deep_dup
        _player = m.player_at(player.location)
        log_puts locals, "試打 #{hand} (%d/%d)" % [i.next, all_hands.size] if logger
        _player.execute(hand.to_sfen)

        # ログに盤面を入れる場合
        # log_puts locals, _player.board
        if locals[:depth] < params[:depth_max]
          # 木の途中
          child_max_hand_info = nega_max(locals.merge(player: _player.opponent_player, depth: locals[:depth].next))
          score = -child_max_hand_info[:score]
          hand_info = HandInfo[hand: hand, score: score, depth: locals[:depth], reading_hands: [hand, *child_max_hand_info[:reading_hands]]]
        else
          # 木の末端
          score = _player.evaluator.score
          @eval_count += 1
          hand_info = HandInfo[hand: hand, score: score, depth: locals[:depth], reading_hands: [hand]]
        end
        log_puts locals, "評価 #{hand_info}" if logger
        ary << hand_info
      end

      sorted_ary = ary.sort_by { |e| -e[:score] }
      _score, top_same_score_ary = ary.group_by { |e| e[:score] }.sort_by { |score, ary| -score }.first
      if params[:random]
        hand_info = top_same_score_ary.sample
      else
        hand_info = top_same_score_ary.first
      end

      if logger
        _candidate = sorted_ary.collect { |e| e.to_s_short }.join(" ")
        log_puts locals, "確定 #{hand_info} 候補:[#{_candidate}]"
      end

      hand_info
    end

    def log_puts(locals, str)
      return unless logger

      str = str.to_s
      if str.match?(/\n/)
        str = "\n" + str
      end
      Warabi.logger.info "%s %d %s %s" % [(locals[:depth] < params[:depth_max] ? "  " : "葉"), locals[:depth], " " * 4 * locals[:depth], str]
    end

    def logger
      Warabi.logger
    end
  end
end
