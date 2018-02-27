# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/brain_spec.rb" -*-
# frozen-string-literal: true

require "timeout"

module Warabi
  class Brain
    def self.human_format(infos)
      infos.collect.with_index do |e, i|
        {
          "順位"       => i.next,
          "候補手"     => e[:hand],
          "読み筋"     => e[:forecast].collect { |e| e.to_s }.join(" "),
          "形勢"       => e[:score2],
          "評価局面数" => e[:eval_times],
          "処理時間"   => e[:sec],
        }
      end
    end

    attr_accessor :player

    def initialize(player)
      @player = player
    end

    def nega_alpha_run(**params)
      thinker = NegaAlphaExecuter.new(params)
      thinker.nega_alpha(player: player)
    end

    def interactive_deepning(**params)
      params = {
        depth_max_range: 1..1,
        time_limit: nil,        # nil: 時間制限なし
      }.merge(params)

      if params[:time_limit]
        params[:out_of_time] ||= Time.now + params[:time_limit]
      end

      children = lazy_all_hands.to_a # 何度も実行するためあえて配列化しておくの重要
      hands = []
      finished = catch params[:out_of_time] do
        params[:depth_max_range].each do |depth_max|
          thinker = NegaAlphaExecuter.new(params.merge(depth_max: depth_max))
          hands = children.collect do |hand|
            hand.sandbox_execute(player.mediator) do
              start_time = Time.now
              info = thinker.nega_alpha(player: player.opponent_player)
              {hand: hand, score: -info[:score], score2: -info[:score] * player.location.value_sign, forecast: info[:forecast], eval_times: info[:eval_times], sec: Time.now - start_time}
            end
          end
        end
        true
      end

      if !children.empty? && hands.empty?
        raise WarabiError, "指し手の候補を絞れません。制限時間を増やすか読みの深度を浅くしてください : #{params}"
      end

      hands.sort_by { |e| -e[:score] }
    end

    def smart_score_list(**params)
      thinker = NegaAlphaExecuter.new(params)

      lazy_all_hands.collect { |hand|
        hand.sandbox_execute(player.mediator) do
          start_time = Time.now
          info = thinker.nega_alpha(player: player.opponent_player)
          {hand: hand, score: -info[:score], socre2: -info[:score] * player.location.value_sign, forecast: info[:forecast], eval_times: info[:eval_times], sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end

    def fast_score_list(**params)
      lazy_all_hands.collect { |hand|
        hand.sandbox_execute(player.mediator) do
          start_time = Time.now
          score = player.evaluator.score
          {hand: hand, score: score, socre2: score * player.location.value_sign, forecast: [], eval_times: 1, sec: Time.now - start_time}
        end
      }.sort_by { |e| -e[:score] }
    end

    def lazy_all_hands
      Enumerator.new do |y|
        move_hands.each do |e|
          y << e
        end
        drop_hands.each do |e|
          y << e
        end
      end
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
    def drop_hands
      Enumerator.new do |y|
        # 直接 piece_box.each_key とせずに piece_keys にいったん取り出している理由は
        # 外側で execute 〜 revert するときの a.each { a.update } の状態になるのを回避するため。
        # each の中で元を更新すると "can't add a new key into hash during iteration" のエラーになる
        piece_keys = player.piece_box.keys
        player.board.blank_points.each do |point|
          piece_keys.each do |piece_key|
            soldier = Soldier.create(piece: Piece[piece_key], promoted: false, point: point, location: player.location)
            if soldier.rule_valid?(player.board)
              y << DropHand.create(soldier: soldier)
            end
          end
        end
      end
    end
  end

  class HandInfo < Hash
    def to_s
      "#{self[:hand]} => #{self[:score]}"
    end
  end

  class NegaAlphaExecuter
    attr_accessor :params
    attr_accessor :eval_counter

    def initialize(params)
      @params = {
        depth_max: 0,           # 最大の深さ
        log_skip_depth: nil,
      }.merge(params)

      @eval_counter = 0
    end

    def nega_alpha(player:, depth: 0, alpha: -Float::INFINITY, beta: Float::INFINITY)
      if logger
        log = -> s { logger_info(s, player: player, depth: depth) }
      end

      if time = params[:out_of_time]
        if time && time <= Time.now
          throw time
        end
      end

      if depth == 0
        @eval_counter = 0
      end

      if depth >= params[:depth_max]
        @eval_counter += 1
        score = player.evaluator.score
        log.call "評価 #{score}" if log
        return HandInfo[score: score, eval_times: eval_counter, forecast: []]
      end

      mediator = player.mediator
      children = player.brain.lazy_all_hands

      best_hand = nil
      forecast = nil
      eval_times = nil
      children_exist = false

      children.each.with_index do |hand, i|
        hand.sandbox_execute(mediator) do
          children_exist = true
          log.call "試指 #{hand} (%d)" % i if log
          info = nega_alpha(player: player.opponent_player, depth: depth + 1, alpha: -beta, beta: -alpha)
          score = -info[:score] # 相手が良くなればなるほど自分にとってはマイナス
          if score > alpha
            alpha = score
            best_hand = hand
            forecast = info[:forecast]
            eval_times = eval_counter
          end
        end
        if alpha >= beta
          break
        end
      end

      # unless children_exist
      #   raise WarabiError, "#{player.call_name}の指し手が一つもありません。すべての駒を取られている可能性があります\n#{mediator.to_bod}"
      # end

      log.call "★確 #{best_hand} 読み数:#{eval_counter}" if log

      HandInfo[hand: best_hand, score: alpha, eval_times: eval_times, forecast: [best_hand, *forecast]]
    end

    private

    def logger_info(str, context)
      return unless logger

      if v = params[:log_skip_depth]
        if context[:depth] >= v
          return
        end
      end

      str = str.lines.collect { |e|
        (" " * 4 * context[:depth]) + e
      }.join.rstrip

      if str.match?(/\n/)
        str = "\n" + str
      end

      Warabi.logger.info "%d %s %s" % [
        context[:depth],
        context[:player].location,
        str,
      ]
    end

    def logger
      Warabi.logger
    end
  end
end
