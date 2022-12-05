# frozen-string-literal: true

module Bioshogi
  class Player
    include PlayerBrainMod

    attr_reader :location
    attr_reader :xcontainer

    attr_reader :executor

    delegate :board, to: :xcontainer

    def initialize(xcontainer:, location:)
      @xcontainer = xcontainer
      @location = location
    end

    def execute(str, options = {})
      @executor = (options[:executor_class] || PlayerExecutorHuman).new(self, str, options)
      @executor.execute
    end

    def opponent_player
      @xcontainer.player_at(location.flip)
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
          e.move_list(xcontainer).any? { |e| e.soldier.place == place } && # 目的地に来れる
          true
      end
    end

    concerning :HelperMethods do
      def judge_key
        if xcontainer.win_player == self
          :win
        else
          :lose
        end
      end

      def call_name
        location.call_name(xcontainer.turn_info.handicap?)
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

      def king_soldier
        soldiers.find { |e| e.piece.key == :king }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end
    end

    concerning :SkillMonitorMethods do
      delegate :attack_infos, :defense_infos, to: :skill_set

      def skill_set
        @skill_set ||= Xtech::SkillSet.new
      end
    end

    concerning :OtherMethods do
      attr_writer :king_moved_counter
      attr_accessor :king_place
      attr_accessor :king_first_moved_turn # 玉が最初に動いた手数
      attr_accessor :death_counter         # 駒が死んだ数

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end

      def used_piece_counts
        @used_piece_counts ||= Hash.new(0)
      end

      # 大駒コンプリートしている？
      def stronger_piece_completed?
        stronger_piece_have_count >= 4
      end

      def stronger_piece_have_count
        c = 0

        # 持駒の大駒
        c += piece_box[:rook] || 0
        c += piece_box[:bishop] || 0

        # 盤上の大駒
        key = location.key
        c += board.piece_count_of(key, :rook)
        c += board.piece_count_of(key, :bishop)

        c
      end
    end

    concerning :MiniClockMethods do
      def personal_clock
        @personal_clock ||= ChessClock::PersonalClock.new
      end
    end

    concerning :PressureMethods do
      # 圧力レベル
      def soldiers_pressure_level
        soldiers.sum(&:pressure_level)
      end

      # 圧力レベル(デバッグ用)
      def pressure_report
        rows = []
        rows += soldiers.collect { |e| {"盤上" => e, "勢力" => e.pressure_level} }
        rows += piece_box.collect { |piece_key, count|
          piece = Piece[piece_key]
          {
            "勢力" => "#{piece.standby_level} * #{count}",
            "持駒" => "#{piece}#{count}",
          }
        }
        rows += [{"勢力" => "合計 #{pressure_level}"}]
        rows += [{"勢力" => "終盤率 #{pressure_rate}"}]
        rows += [{"勢力" => "序盤率 #{1.0 - pressure_rate}"}]
        rows
      end

      def pressure_level
        soldiers_pressure_level + piece_box.pressure_level
      end

      def pressure_rate(max = 16)
        pressure_level.clamp(0, max).fdiv(max)
      end
    end
  end
end
