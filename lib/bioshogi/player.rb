# frozen-string-literal: true

module Bioshogi
  class Player
    include Ai::PlayerBrainMod
    include PieceBoxMethods
    include SoldierMethods
    include OtherMethods
    include PressureMethods

    attr_reader :location
    attr_reader :container
    attr_reader :executor

    delegate :board, to: :container

    def initialize(container:, location:)
      @container = container
      @location = location
    end

    def execute(str, options = {})
      @executor = (options[:executor_class] || PlayerExecutor::Human).new(self, str, options)
      @executor.execute
    end

    def opponent_player
      @container.player_at(location.flip)
    end

    # 自分と相手
    def self_and_opponent
      [self, opponent_player]
    end

    def op
      opponent_player
    end

    def my
      self
    end

    def soldier_create(object, options = {})
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
          e.promoted == promoted &&                                      # 成っているかどうかで絞る
          e.piece.key == piece_key &&                                    # 同じ種類に絞る
          e.move_list(container).any? { |e| e.soldier.place == place } && # 目的地に来れる
          true
      end
    end

    concerning :HelperMethods do
      def judge_key
        if container.win_player == self
          :win
        else
          :lose
        end
      end

      def call_name
        location.call_name(container.turn_info.handicap?)
      end
    end

    def skill_set
      @skill_set ||= Explain::SkillSet.new
    end
    delegate :attack_infos, :defense_infos, to: :skill_set

    def single_clock
      @single_clock ||= SingleClock.new
    end
  end
end
