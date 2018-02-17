# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Brain
    attr_accessor :player

    def initialize(player)
      @player = player
    end

    def think_by_minmax(params = {})
      NegaMaxRunner.run({player: player}.merge(params))
    end

    def all_hands
      [*move_hands, *direct_hands]
    end

    def best_hand
      score_list.first[:hand]
    end

    def score_list
      list = []
      all_hands.each do |hand|
        m = player.mediator.deep_dup
        _player = m.player_at(player.location)
        _player.execute(hand.to_kif)
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
    def self.run(params)
      object = new(params)
      object.nega_max(params)
    end

    attr_accessor :eval_count

    def initialize(params)
      @params = {
        random: false,
      }.merge(params)
      @eval_count = 0
    end

    def nega_max(locals = {})
      locals = {
        depth: 0,            # 最大の深さ
        # temporay
        level: 0,            # 現在の深さ
      }.merge(@params).merge(locals)

      logs = []
      player = locals[:player]
      mediator = player.mediator
      all_hands = player.brain.all_hands
      ary = all_hands.each.with_object([]).with_index{|(hand, ary), index|
        mediator.deep_dup.tap do |mediator|
          _player = mediator.player_at(player.location)
          mhand = "#{hand}"
          log_puts locals, "試打 #{mhand} (%d/%d)" % [index.next, all_hands.size]
          _player.execute(hand)
          # ログに盤面を入れる場合
          # log_puts locals, _player.board
          child_max_hand_info = nil
          if locals[:level] < locals[:depth]
            # 木の途中
            child_max_hand_info = nega_max(locals.merge(player: _player.opponent_player, level: locals[:level].next))
            score = -child_max_hand_info[:score]
            hand_info = HandInfo[hand: mhand, score: score, level: locals[:level], reading_hands: [mhand] + child_max_hand_info[:reading_hands]]
          else
            # 木の末端
            score = _player.evaluator.score
            @eval_count += 1
            # p [:@@eval_count, @eval_count]
            hand_info = HandInfo[hand: mhand, score: score, level: locals[:level], reading_hands: [mhand]]
          end
          log_puts locals, "評価 #{hand_info}"
          ary << hand_info
        end
      }

      sorted_ary = ary.sort_by{|e|-e[:score]}
      _candidate = sorted_ary.collect{|e|e.to_s_short}.join(" ")
      _score, top_same_score_ary = ary.group_by{|e|e[:score]}.sort_by{|score, ary|-score}.first
      if @params[:random]
        hand_info = top_same_score_ary.sample
      else
        # テスト時にゆらぐのを防ぐため強引だけど文字列化してソートして先頭を取り出す ← これが微妙。同じスコアなら二つ返した方がいいかも。ただし最後なら。
        hand_info = top_same_score_ary.sort_by(&:to_s).first
      end

      log_puts locals, "確定 #{hand_info} 候補:[#{_candidate}]"

      hand_info
    end

    def log_puts(locals, str)
      str = str.to_s
      if str.match?(/\n/)
        str = "\n" + str
      end
      Warabi.logger.info "%s %d %s %s" % [(locals[:level] < locals[:depth] ? "  " : "葉"), locals[:level], " " * 4 * locals[:level], str]
    end
  end
end
