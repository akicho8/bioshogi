# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  class Brain
    def initialize(player)
      @player = player
    end

    def all_ways
      soldiers_ways + pieces_ways
    end

    def best_way
      eval_list.first[:way]
    end

    # def doredore(depth = 0)
    #   mediator = @player.mediator
    #   score_info = all_ways.each.with_object([]){|way, ary|
    #     mediator.sandbox_for do |_mediator|
    #       _player = _mediator.player_at(@player.location)
    #       _player.execute(way)
    #       ary << {way: way, score: _player.evaluate}
    #       
    #       
    #     end
    #   }
    #   score_info.sort_by{|e|-e[:score]}
    # end

    def eval_list
      score_info = all_ways.each.with_object([]){|way, ary|
        @player.mediator.sandbox_for do |_mediator|
          _player = _mediator.player_at(@player.location)
          _player.execute(way)
          ary << {way: way, score: _player.evaluate}
        end
      }
      score_info.sort_by{|e|-e[:score]}
    end

    # 盤上の駒の全手筋
    def soldiers_ways
      list = []

      mpoints = @player.soldiers.collect{|soldier|
        soldier.moveable_points.collect{|point|{soldier: soldier, point: point}}
      }.flatten

      mpoints.collect{|mpoint|
        soldier = mpoint[:soldier]
        point = mpoint[:point]

        promoted_trigger = nil

        # 移動先が成れる場所かつ、駒が成れる駒で、駒は成ってない状態であれば成る(ことで行き止まりの反則を防止する)
        if point.promotable?(@player.location) && soldier.piece.promotable? && !soldier.promoted?
          promoted_trigger = true
        end

        [point.name, soldier.piece_current_name, (promoted_trigger ? "成" : ""), "(", soldier.point.number_format, ")"].join
      }
    end

    # 持駒の全打筋
    def pieces_ways
      list = []
      @player.board.blank_points.each do |point|
        @player.pieces.each do |piece|
          if @player.get_errors(MiniSoldier[point: point, piece: piece]).empty?
            list << [point.name, piece.name, "打"].join
          end
        end
      end
      list
    end
  end
end
