# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Brain
    attr_accessor :player

    def initialize(player)
      @player = player
    end

    def nega_max_run(**params)
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
      hands = []
      all_hands.each do |hand|
        # m = player.mediator.deep_dup
        # _player = m.player_at(player.location)
        # _player.execute(hand.to_sfen, executor_class: PlayerExecutorBrain)
        # hands << {hand: hand, score: _player.evaluator.score}

        memento = player.mediator.create_memento
        player.execute(hand.to_sfen, executor_class: PlayerExecutorBrain)
        hands << {hand: hand, score: player.evaluator.score}
        player.mediator.restore_memento(memento)
      end
      hands.sort_by { |e| -e[:score] }
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
      "%s => %d" % [self[:hand], self[:score]]
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

      hands = []

      all_hands.each.with_index do |hand, i|
        memento = mediator.create_memento
        # m = mediator.deep_dup
        # _player = m.player_at(player.location)
        player.execute(hand.to_sfen, executor_class: PlayerExecutorBrain)
        count = player.mediator.position_map[player.mediator.position_hash] # 同一局面数
        # ログに盤面を入れる場合
        # log_puts locals, _player.board
        if count == 0 && locals[:depth] < params[:depth_max]
          log_puts locals, "試指 #{hand} (%d/%d)" % [i.next, all_hands.size] if logger

          # 相手が良くなればなるほど自分にとってはマイナス
          info = nega_max(locals.merge(player: player.opponent_player, depth: locals[:depth].next))
          score = -info[:score]
          info = HandInfo[hand: hand, score: score, depth: locals[:depth], hands: [hand, *info[:hands]]]

          log_puts locals, "評価 #{info}" if logger
        else
          # 木の末端
          score = player.evaluator.score2
          @eval_count += 1
          info = HandInfo[hand: hand, score: score, depth: locals[:depth], hands: [hand]]
          log_puts locals, "試指 #{hand} => #{score}" if logger
        end
        mediator.restore_memento(memento)
        hands << info
      end

      sorted_hands = hands.sort_by { |e| -e[:score] }
      info = sorted_hands.first

      if logger
        # _candidate = sorted_hands.collect(&:to_s2).join(" ")
        log_puts locals, "★確 #{info} 読み数:#{eval_count}"
      end

      info
    end

    def log_puts(locals, str)
      return unless logger

      str = str.to_s
      if str.match?(/\n/)
        str = "\n" + str
      end
      Warabi.logger.info "%d %s %s %s" % [
        locals[:depth],
        locals[:player].location,
        " " * 4 * locals[:depth],
        str,
      ]
    end

    def logger
      Warabi.logger
    end
  end
end
