# -*- coding: utf-8; compile-command: "bundle execute rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Bioshogi
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
        @skill_set ||= SkillSet.new
      end
    end

    concerning :OtherMethods do
      attr_writer :king_moved_counter
      attr_accessor :king_place

      def king_moved_counter
        @king_moved_counter ||= 0
      end

      def king_place
        @king_place ||= king_soldier&.place
      end

      def king_place_update
        @king_place = king_soldier&.place
      end
    end

    concerning :MiniClockMethods do
      def personal_clock
        @personal_clock ||= ChessClock::PersonalClock.new
      end
    end

    concerning :BrainMethods do
      def evaluator(**options)
        (options[:evaluator_class] || EvaluatorBase).new(self, options)
      end

      def brain(**params)
        Brain.new(self, **params)
      end

      # 非合法手を含む(ピンを考慮しない)すべての指し手の生成
      def normal_all_hands
        Enumerator.new do |y|
          move_hands.each do |e|
            y << e
          end
          drop_hands.each do |e|
            y << e
          end
        end
      end

      # ピンを考慮した合法手の生成
      #
      # ▼PinCheck機構つきのMakeMoveの提案 - Bonanzaソース完全解析ブログ
      # http://d.hatena.ne.jp/LS3600/20091229
      # > MakeMoveのあとに王手がかかっているかを調べてはならない
      # > MakeMove → InCheck(自王に王手がかかっているかを判定)→(自玉に王手がかかっているなら) UnMakeMove というのは良くない
      # > それというのも、MakeMoveでは局面ハッシュ値やoccupied bitboardなどを更新したりしているのが普通であり、王手がかかっているのがわかってから局面を戻すというのは無駄なやりかただ。
      #
      # 枝刈りされる前の状態でピンを考慮すると重すぎて動かないのでどこにこのチェックを入れるかが難しい
      #
      def legal_all_hands
        Enumerator.new do |y|
          move_hands.each do |e|
            if e.legal_move?(mediator)
              y << e
            end
          end
          drop_hands.each do |e|
            if e.legal_move?(mediator)
              y << e
            end
          end
        end
      end

      # 盤上の駒の全手筋
      def move_hands(**options)
        options = {
          promoted_preferred: true,  # 成と不成は成だけ生成する？
          king_captured_only: false, # 玉を取る手だけ生成する？
        }.merge(options)

        Enumerator.new do |y|
          soldiers.each do |soldier|
            soldier.move_list(board, options).each do |move_hand|
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
          piece_keys = piece_box.keys
          board.blank_places.each do |place|
            piece_keys.each do |piece_key|
              soldier = Soldier.create(piece: Piece[piece_key], promoted: false, place: place, location: location)
              if soldier.rule_valid?(board)
                y << DropHand.create(soldier: soldier)
              end
            end
          end
        end
      end

      # 相手に対して王手をしている手の取得
      # Enumerator なので mate_move_hands.first で最初の1件の処理だけになる
      def mate_move_hands
        move_hands(promoted_preferred: true, king_captured_only: true)
      end

      # 王手をかけている？
      def mate_advantage?
        mate_move_hands.any?
      end

      # 王手をかけられている？
      def mate_danger?
        opponent_player.mate_advantage?
      end
    end

    private

    def move_list(soldier, **options)
      Movabler.move_list(board, soldier, options)
    end
  end
end
