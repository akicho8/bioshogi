# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Player
    attr_accessor :location
    attr_accessor :mediator
    attr_accessor :executor

    attr_accessor :last_captured_piece

    def initialize(mediator, **params)
      super() if defined? super

      @mediator = mediator

      if v = params[:location]
        self.location = v
      end

      if params[:pieces_add]
        pieces_add
      end
    end

    def board
      @mediator.board
    end

    def flip_player
      @mediator.player_at(location.flip)
    end

    # 先手後手を設定は適当でいい
    #   player.location = :white
    #   player.location = "後手"
    def location=(key)
      @location = Location[key]
    end

    # 平手の初期配置
    def piece_plot
      soldiers = PresetInfo.fetch("平手").board_parser.location_adjust[location.key]
      soldiers.each do |soldier|
        piece_box.pick_out(soldier.piece)
        board.put_on(soldier, validate: true)
      end
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_stand:false にすると楽ちん
    #   player.soldier_create(["５五飛", "３三飛"], from_stand: false)
    #   player.soldier_create("#{point}馬")
    def soldier_create(soldier_or_str, **options)
      if soldier_or_str.kind_of? Array
        soldier_or_str.each do |e|
          soldier_create(e, options)
        end
      else
        options = {
          from_stand: true, # 持駒から取り出して配置する？
        }.merge(options)

        if soldier_or_str.kind_of?(String)
          if soldier_or_str.to_s.gsub(/_/, "").empty? # テストを書きやすくするため
            return
          end
          soldier = Soldier.from_str(soldier_or_str, location: location)
        else
          soldier = soldier_or_str
        end
        if options[:from_stand]
          piece_box.pick_out(soldier.piece) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        board.put_on(soldier, validate: true)
      end
    end

    def move_to(from, to, promote_trigger = false)
      @last_captured_piece = nil

      from = Point.fetch(from)
      to = Point.fetch(to)

      # 破壊的な処理をする前の段階でエラーチェックを行う
      if true
        if promote_trigger
          if !from.promotable?(location) && !to.promotable?(location)
            raise NotPromotable, "成りを入力しましたが#{from}から#{to}への移動では成れません"
          end

          soldier = board.lookup(from)
          if soldier.promoted
            raise AlredyPromoted, "成りを明示しましたが#{soldier.point}の#{soldier.piece.name}はすでに成っています"
          end
        end

        if (soldier = board.lookup(from)) && location != soldier.location
          raise ReversePlayerPieceMoveError, "相手の駒を動かそうとしています。#{location}の手番で#{soldier}を#{to}に動かそうとしています\n#{mediator.to_bod}"
        end
      end

      # 移動先に相手の駒があれば取って駒台に移動する
      if target_soldier = board.lookup(to)
        if target_soldier.location == location
          raise SamePlayerBattlerOverwrideError, "移動先の#{to}には自分の駒(#{target_soldier})があります"
        end
        board.pick_up!(to)
        piece_box.add(target_soldier.piece.key => 1)
        @mediator.kill_counter += 1
        @last_captured_piece = target_soldier.piece
      end

      from_soldier = board.pick_up!(from)
      attributes = from_soldier.attributes
      if promote_trigger
        attributes[:promoted] = true
      end
      attributes[:point] = to
      board.put_on(Soldier.create(attributes), validate: true)
    end

    # 棋譜の入力
    def execute(str)
      @executor = PlayerExecutor.new(self)
      @executor.execute(str)

      if Warabi.config[:skill_set_flag]
        if Position.size_type == :board_size_9x9
          if mediator.mediator_options[:skill_set_flag]
            skill_monitor.execute
          end
        end
      end

      @mediator.hand_logs << @executor.hand_log
    end

    concerning :HelperMethods do
      def judge_key
        if mediator.win_player == self
          :win
        else
          :lose
        end
      end
    end

    concerning :Pieceable do
      def piece_box
        @piece_box ||= PieceBox.new
      end

      def pieces_add(str = "歩9角飛香2桂2銀2金2玉")
        piece_box.add(Piece.s_to_h(str))
      end

      def pieces_set(str)
        piece_box.set(Piece.s_to_h(str))
      end

      def hold_pieces_snap
        "#{call_name}の持駒：#{piece_box.to_s.presence || "なし"}"
      end

      def call_name
        location.call_name(mediator.turn_info.handicap?)
      end

      def to_sfen
        piece_box.to_sfen(location)
      end

      def to_csa
        piece_box.to_csa(location)
      end
    end

    concerning :BattlerMethods do
      def soldiers
        board.surface.values.find_all { |e| e.location == location }
      end

      def to_s_soldiers
        soldiers.collect(&:name_without_location).sort.join(" ")
      end
    end

    concerning :SkillMonitorMethods do
      def skill_set
        @skill_set ||= SkillSet.new
      end

      delegate :attack_infos, :defense_infos, to: :skill_set

      def skill_monitor
        SkillMonitor.new(self)
      end
    end

    concerning :EvaluatorMethods do
      def evaluator
        Evaluator.new(self)
      end
    end

    concerning :BrainMethods do
      included do
        delegate :evaluate, :score_percentage, to: :evaluator
      end

      def brain
        Brain.new(self)
      end
    end

    private

    def moved_list(soldier)
      Movabler.moved_list(board, soldier)
    end
  end
end
