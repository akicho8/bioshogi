# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
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
        :random => true,        # 未実装
      }.merge(params)
      @eval_count = 0
    end

    def nega_max(params = {})
      params = {
        :depth => 0,            # 最大の深さ
        # temporay
        :level => 0,            # 現在の深さ
      }.merge(params)
      logs = []
      player = params[:player]
      mediator = player.mediator
      all_hands = player.brain.all_hands
      ary = all_hands.each.with_object([]).with_index{|(hand, ary), index|
        mediator.sandbox_for do |_mediator|
          _player = _mediator.player_at(player.location)
          mhand = "#{_player.location.mark}#{hand}"
          log_puts params, "試打 #{mhand} (%d/%d)" % [index.next, all_hands.size]
          _player.execute(hand)
          child_max_hand_info = nil
          if params[:level] < params[:depth]
            # 木の途中
            child_max_hand_info = nega_max(params.merge(:player => _player.next_player, :level => params[:level].next))
            score = -child_max_hand_info[:score]
            hand_info = HandInfo[:hand => mhand, :score => score, :level => params[:level], :reading_hands => [mhand] + child_max_hand_info[:reading_hands]]
          else
            # 木の末端
            score = _player.evaluate
            @eval_count += 1
            # p [:@@eval_count, @eval_count]
            hand_info = HandInfo[:hand => mhand, :score => score, :level => params[:level], :reading_hands => [mhand]]
          end
          log_puts params, "評価 #{hand_info}"
          ary << hand_info
        end
      }
      # Maxなものを選択する
      sorted_ary = ary.sort_by{|e|e[:score]}
      hand_info = sorted_ary.last
      _debug_info = sorted_ary.collect{|e|e.to_s_short}.join(" ")
      log_puts params, "確定 #{hand_info} 候補:[#{_debug_info}]"
      # logs << hand_info[:hand]

      hand_info
    end

    def log_puts(params, str)
      # puts "%s %d %s %s" % [(params[:level] < params[:depth] ? "  " : "葉"), params[:level], " " * 4 * params[:level], str]
    end
  end

  class Brain
    def initialize(player)
      @player = player
    end

    # {:hand=>"▲1八飛(17)", :score=>-3230, :level=>0, :reading_hands=>["▲1八飛(17)", "▽1五歩(14)", "▲1五香(16)", "▽1五香(13)"]}
    def think_by_minmax(options = {})
      NegaMaxRunner.run({:player => @player}.merge(options))
    end

    def all_hands
      soldiers_hands + pieces_hands
    end

    def best_hand
      eval_list.first[:hand]
    end

    # def doredore(depth = 0)
    #   if depth == 0
    #     mediator = @player.mediator
    #     score_info = all_hands.each.with_object([]){|hand, ary|
    #       mediator.sandbox_for do |_mediator|
    #         _player = _mediator.player_at(@player.location)
    #         _player.execute(hand)
    #         ary << {:hand => hand, :score => _player.evaluate}
    #       end
    #     }
    #     score_info.sort_by{|e|-e[:score]}
    #     ary << {:hand => hand, :score => _player.evaluate}
    #   end
    # end

    def eval_list
      score_info = all_hands.each.with_object([]){|hand, ary|
        @player.mediator.sandbox_for do |_mediator|
          _player = _mediator.player_at(@player.location)
          _player.execute(hand)
          ary << {hand: hand, score: _player.evaluate}
        end
      }
      score_info.sort_by{|e|-e[:score]}
    end

    # 盤上の駒の全手筋
    def soldiers_hands
      __soldiers_hands.collect(&:to_hand)
    end

    def __soldiers_hands
      @player.soldiers.collect{|soldier|soldier.movable_infos}.flatten
    end

    # 持駒の全打筋
    def pieces_hands
      __pieces_hands.collect(&:to_hand)
    end

    def __pieces_hands
      @player.board.blank_points.collect do |point|
        @player.pieces.collect do |piece|
          m = MiniSoldier[point: point, piece: piece]
          if @player.get_errors(m).empty?
            PieceStake[m]
          end
        end
      end.flatten.compact
    end
  end
end
