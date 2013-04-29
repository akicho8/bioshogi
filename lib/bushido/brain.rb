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

  class Brain
    def self.nega_max(params)
      params = {
        :depth => 0,            # 最大の深さ
        # temporay
        :level => 0,            # 現在の深さ
        :ways => [],
      }.merge(params)
      logs = []
      player = params[:player]
      mediator = player.mediator
      all_ways = player.brain.all_ways
      ary = all_ways.each.with_object([]).with_index{|(way, ary), index|
        mediator.sandbox_for do |_mediator|
          _player = _mediator.player_at(player.location)
          hand = "#{_player.location.mark}#{way}"
          log_puts params, "試打 #{hand} (%d/%d)" % [index.next, all_ways.size]
          _player.execute(way)
          child_max_hand_info = nil
          if params[:level] < params[:depth]
            # 木の途中
            child_max_hand_info = nega_max(params.merge(:player => _player.next_player, :level => params[:level].next))
            # p _logs
            # logs += _logs
            # params[:ways] << child_max_hand_info[:hand]
            # p params[:ways]
            score = -child_max_hand_info[:score]
            hand_info = HandInfo[:hand => hand, :score => score, :level => params[:level], :hands => [hand] + child_max_hand_info[:hands]]
          else
            # 木の末端
            score = _player.evaluate
            hand_info = HandInfo[:hand => hand, :score => score, :level => params[:level], :hands => [hand]]
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

    def self.log_puts(params, str)
      puts "%s %d %s %s" % [(params[:level] < params[:depth] ? "  " : "葉"), params[:level], " " * 4 * params[:level], str]
    end

    def initialize(player)
      @player = player
    end

    def all_ways
      soldiers_ways + pieces_ways
    end

    def best_way
      eval_list.first[:way]
    end

    def doredore(depth = 0)
      if depth == 0
        mediator = @player.mediator
        score_info = all_ways.each.with_object([]){|way, ary|
          mediator.sandbox_for do |_mediator|
            _player = _mediator.player_at(@player.location)
            _player.execute(way)
            ary << {:way => way, :score => _player.evaluate}
          end
        }
        score_info.sort_by{|e|-e[:score]}
        ary << {:way => way, :score => _player.evaluate}
      end

      # mediator = @player.mediator
      # score_info = all_ways.each.with_object([]){|way, ary|
      #   mediator.sandbox_for do |_mediator|
      #     _player = _mediator.player_at(@player.location)
      #     _player.execute(way)
      #     ary << {:way => way, :score => _player.evaluate}
      #   end
      # }
      # score_info.sort_by{|e|-e[:score]}
    end

    def eval_list
      score_info = all_ways.each.with_object([]){|way, ary|
        @player.mediator.sandbox_for do |_mediator|
          _player = _mediator.player_at(@player.location)
          _player.execute(way)
          ary << {:way => way, :score => _player.evaluate}
        end
      }
      score_info.sort_by{|e|-e[:score]}
    end

    # 盤上の駒の全手筋
    def soldiers_ways
      list = []

      mpoints = @player.soldiers.collect{|soldier|
        soldier.moveable_points.collect{|point|{:soldier => soldier, :point => point}}
      }.flatten

      mpoints.collect{|mpoint|
        soldier = mpoint[:soldier]
        point = mpoint[:point]

        promoted_trigger = nil

        # 移動先が成れる場所かつ、駒が成れる駒で、駒は成ってない状態であれば成る(ことで行き止まりの反則を防止する)
        if point.promotable?(@player.location) && soldier.piece.promotable? && !soldier.promoted?
          promoted_trigger = true
        end

        # ここのテストを書くこと(消すなよここ)
        # Vpos._promotable_length = 0 だった場合に promoted_trigger は true にならないので1段に歩を打ってしまう可能性がある
        # if @player.moveable_points(point, soldier.piece, (promoted_trigger || soldier.promoted?), :board_object_collision_skip => true).empty?
        # end

        [point.name, soldier.piece_current_name, (promoted_trigger ? "成" : ""), "(", soldier.point.number_format, ")"].join

      }.compact
    end

    # 持駒の全打筋
    def pieces_ways
      list = []
      @player.board.blank_points.each do |point|
        @player.pieces.each do |piece|
          if piece.name == "香"
            p [point, piece, false]
            p @player.get_errors(point, piece, false)
          end

          if @player.get_errors(point, piece, false).empty?
            list << [point.name, piece.name, "打"].join
          end
        end
      end
      list
    end
  end
end
