# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Player
    attr_reader :location
    attr_reader :mediator

    attr_reader :executor

    delegate :board, to: :mediator

    def initialize(mediator:, location:)
      @mediator = mediator
      @location = location
    end

    def execute(str, **options)
      @executor = (options[:executor_class] || PlayerExecutorHuman).new(self, str, options)
      @executor.execute
    end

    def opponent_player
      @mediator.player_at(location.flip)
    end

    def soldier_create(object, **options)
      if object.kind_of?(Array)
        object.each do |e|
          soldier_create(e, options)
        end
      else
        if object.kind_of?(String)
          soldier = Soldier.from_str(object, location: location)
        else
          soldier = object
        end
        if options[:from_stand]
          piece_box.pick_out(soldier.piece)
        end
        board.place_on(soldier, validate: true)
      end
    end

    def placement_from_human(str)
      soldiers = InputParser.scan(str).collect { |s| Soldier.from_str(s, location: location) }
      board.placement_from_soldiers(soldiers)
    end

    def candidate_soldiers(piece:, promoted:, place:)
      piece_key = piece.key
      soldiers.find_all do |e|
        true &&
          e.promoted == promoted &&                                   # 成っているかどうかで絞る
          e.piece.key == piece_key &&                                 # 同じ種類に絞る
          e.move_list(board).any? { |e| e.soldier.place == place } && # 目的地に来れる
          true
      end
    end

    concerning :HelperMethods do
      def judge_key
        if mediator.win_player == self
          :win
        else
          :lose
        end
      end

      def call_name
        location.call_name(mediator.turn_info.handicap?)
      end
    end

    concerning :PieceBoxMethods do
      attr_writer :piece_box

      def piece_box
        @piece_box ||= PieceBox.new
      end

      def pieces_add(str = "歩9角飛香2桂2銀2金2玉")
        piece_box.add(Piece.s_to_h(str))
      end

      def pieces_set(str)
        piece_box.set(Piece.s_to_h(str))
      end

      def piece_box_as_header
        "#{call_name}の持駒：#{piece_box.to_s.presence || "なし"}"
      end

      def to_sfen
        piece_box.to_sfen(location)
      end

      def to_csa
        piece_box.to_csa(location)
      end
    end

    concerning :SoldierMethods do
      def soldiers
        board.surface.values.find_all { |e| e.location == location }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end
    end

    concerning :SkillMonitorMethods do
      delegate :attack_infos, :defense_infos, to: :skill_set
      def skill_set
        @skill_set ||= SkillSet.new
      end
    end

    concerning :BrainMethods do
      def evaluator(**options)
        (options[:evaluator_class] || EvaluatorBase).new(self, options)
      end

      def brain(**params)
        Brain.new(self, **params)
      end
    end

    private

    def move_list(soldier, **options)
      Movabler.move_list(board, soldier, options)
    end
  end
end
