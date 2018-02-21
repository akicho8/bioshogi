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

        # memento = player.mediator.create_memento

        # hand = player.execute(hand.to_sfen, executor_class: PlayerExecutorBrain)
        hand.execute(player.mediator)
        hands << {hand: hand, score: player.evaluator.score}
        hand.revert(player.mediator)

        # player.mediator.restore_memento(memento)
      end
      hands.sort_by { |e| -e[:score] }
    end

    # 盤上の駒の全手筋
    def move_hands
      Enumerator.new do |y|
        player.soldiers.each do |soldier|
          soldier.move_list(player.board, promoted_preferred: true).each do |move_hand|
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
        debug_level: nil,
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
      score_max = -Float::INFINITY
      score_max_object = nil

      all_hands.each.with_index do |hand, i|
        # memento = mediator.create_memento
        # m = mediator.deep_dup
        # _player = m.player_at(player.location)

        # hand2 = player.execute(hand.to_sfen, executor_class: PlayerExecutorBrain)

        hand2 = hand
        foo = player.mediator.to_long_sfen_without_turn
        hand2.execute(player.mediator)

        # count = player.mediator.position_map[player.mediator.position_hash] # 同一局面数
        # count == 0 && 
        # ログに盤面を入れる場合
        if locals[:depth] < params[:depth_max]
          # log_puts locals, "-" * 40
          log_puts locals, "試指 #{hand} (%d/%d)" % [i.next, all_hands.size] if logger
          # log_puts locals, mediator.to_bod

          # 相手が良くなればなるほど自分にとってはマイナス
          info = nega_max(locals.merge(player: player.opponent_player, depth: locals[:depth].next))
          score = -info[:score]
          info = HandInfo[hand: hand, score: score, depth: locals[:depth], hands: [hand, *info[:hands]]]

          log_puts locals, "評価 #{info} (%d/%d)" % [i.next, all_hands.size] if logger
        else
          # 自分か相手かはわからない
          score = player.evaluator.score
          @eval_count += 1
          info = HandInfo[hand: hand, score: score, depth: locals[:depth], hands: [hand]]
          log_puts locals, "試指 #{hand} => #{score}" if logger
        end

        hand2.revert(mediator)
        raise if player.mediator.to_long_sfen_without_turn != foo
        # mediator.turn_info.counter -= 1

        if info[:score] > score_max
          score_max = info[:score]
          score_max_object = info
        end

        if locals[:depth] == 0
          hands << info
        end
      end

      if logger
        if locals[:depth] == 0
          hands = hands.sort_by { |e| -e[:score] }
          rows = hands.collect { |e|
            row = e[:hands].each.with_index.inject({}) {|a, (e, i)| a.merge(i => e)}
            {score: e[:score]}.merge(row)
          }
          log_puts locals, rows.to_t
        end

        log_puts locals, "抽出\n#{hands.collect(&:to_s).join("\n")}"
        log_puts locals, "★確 #{score_max_object} 読み数:#{eval_count}"
      end

      score_max_object
    end

    def log_puts(locals, str)
      return unless logger

      if params[:debug_level]
        if locals[:depth] >= params[:debug_level]
          return
        end
      end

      str = str.lines.collect { |e|
        (" " * 4 * locals[:depth]) + e
      }.join.rstrip

      if str.match?(/\n/)
        str = "\n" + str
      end

      Warabi.logger.info "%d %s %s" % [
        locals[:depth],
        locals[:player].location,
        str,
      ]
    end

    def logger
      Warabi.logger
    end
  end
end
