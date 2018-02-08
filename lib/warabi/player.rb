# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# frozen-string-literal: true

module Warabi
  class Player
    # attr_accessor :name
    attr_accessor :location
    attr_accessor :mediator
    attr_accessor :runner

    attr_accessor :last_piece_taken_from_opponent

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

    def reverse_player
      @mediator.player_at(location.reverse)
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
        piece_pick_out(soldier.piece)
        battlers_create_from_soldier(soldier)
      end
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_stand:false にすると楽ちん
    #   player.battlers_create(["５五飛", "３三飛"], from_stand: false)
    #   player.battlers_create("#{point}馬")
    #   player.battlers_create({point: point, piece: Piece["角"], promoted: true}, from_stand: false)
    def battlers_create(soldier_or_str, **options)
      options = {
        from_stand: true, # 持駒から取り出して配置する？
      }.merge(options)

      Array.wrap(soldier_or_str).each do |soldier_or_str|
        if soldier_or_str.kind_of?(String)
          if soldier_or_str.to_s.gsub(/_/, "").empty? # テストを書きやすくするため
            next
          end
          soldier = Soldier.from_str(soldier_or_str, location: location)
        else
          soldier = soldier_or_str
        end
        if options[:from_stand]
          piece_pick_out(soldier.piece) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        battlers_create_from_soldier(soldier)
      end
    end

    # # 盤上の自分の駒
    # def battlers
    #   @battlers
    #   # @ board.surface.values.find_all{|battler|battler.player == self}
    # end

    # 盤上の駒を from から to に移動する。成るなら promote_trigger を有効に。
    def move_to(from, to, promote_trigger = false)
      @last_piece_taken_from_opponent = nil # 最後に取った駒 FIXME:名前がだめ

      from = Point.fetch(from)
      to = Point.fetch(to)

      # 破壊的な処理をする前の段階でエラーチェックを行う
      if true
        if promote_trigger
          if !from.promotable?(location) && !to.promotable?(location)
            raise NotPromotable, "成りを入力しましたが #{from.name} から #{to.name} への移動では成れません"
          end

          battler = board.lookup(from)
          if battler.promoted
            raise AlredyPromoted, "成りを入力しましたが #{battler.point.name} の #{battler.piece.name} はすでに成っています"
          end
        end

        if (battler = board.lookup(from)) && location != battler.location
          raise ReversePlayerPieceMoveError, "相手の駒を動かそうとしています。#{location}の手番で#{battler.point}にある#{battler.location}の#{battler.piece_current_name}を#{to}に動かそうとしています\n#{board_with_pieces}"
        end
      end

      from_battler = board.pick_up!(from)

      # 移動先に相手の駒があれば取って駒台に移動する
      to_battler = board.lookup(to)
      if to_battler
        if to_battler.player == self
          raise SamePlayerBattlerOverwrideError, "移動先の #{to.name} には自分の駒 #{to_battler.mark_with_formal_name.inspect} があります"
        end
        board.pick_up!(to)
        piece_box.add(to_battler.piece.key => 1)
        @mediator.kill_counter += 1
        @last_piece_taken_from_opponent = to_battler.piece
        to_battler.player.battlers.delete(to_battler)
      end

      if promote_trigger
        from_battler.promoted = true
      end

      from_battler.point = to
      put_on_with_valid(from_battler)
    end

    # # # 前の位置(同に使う)
    # def point_logs
    #   @mediator.point_logs
    # end

    # 棋譜の入力
    def execute(str)
      # if str == "投了"
      #   return
      # end
      @runner = Runner.new(self).execute(str)
      if Warabi.config[:skill_set_flag]
        if Position.size_type == :board_size_9x9
          if mediator.mediator_options[:skill_set_flag]
            skill_monitor.execute
          end
        end
      end
      @mediator.hand_log_push(self)
    end

    def inspect
      [("-" * 40), super, board_with_pieces, ("-" * 40)].join("\n")
    end

    # 盤面と持駒(表示用)
    def board_with_pieces
      s = []
      s << board.to_s
      s << "#{hold_pieces_snap}\n"
      s.join
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
      included do
        attr_accessor :piece_box
      end

      def initialize(*)
        super
        @piece_box = PieceBox.new
      end

      delegate :pieces, to: :piece_box

      def piece_pick_out(piece)
        piece_box.pick_out(piece)
        # index = @pieces.find_index { |e| e.key == piece.key }
        # index or raise HoldPieceNotFound, "#{location.name}の手番で持駒に #{piece.name.inspect} がありません\n#{board_with_pieces}"
        # @pieces.slice!(index)
      end

      # 持駒の名前一覧(表示・デバッグ用)
      def piece_names
        piece_box.pieces.collect(&:name).sort
      end

      # 持駒を捨てる
      def piece_box_clear
        piece_box.clear
      end

      # 配布して持駒にする
      #
      #   player = Player.new
      #   player.pieces_add("飛 歩二")
      #   player.piece_box.to_s # => "飛 歩二"
      #
      def pieces_add(str = "歩9角飛香2桂2銀2金2玉")
        piece_box.add(Piece.s_to_h(str))
      end

      # 持駒表記変換 (コード → 人間表記)
      #   pieces_set("歩2 飛") # => [Piece["歩"], Piece["歩"], Piece["飛"]]
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

    # 盤上の駒関連
    concerning :BattlerMethods do
      included do
        attr_accessor :battlers
      end

      def initialize(*)
        super
        # インスタンス変数は何もしなければ自動的に Marshal の対象になる
        @battlers = []
      end

      def battlers_create_from_soldier(soldier)
        battler = Battler.create(soldier.attributes.merge(player: self))
        put_on_with_valid(battler)
        @battlers << battler
      end

      # 盤上の駒の名前一覧(表示・デバッグ用)
      #   battler_names # => ["△５五飛↓"]
      def battler_names
        @battlers.collect(&:mark_with_formal_name).sort
      end

      # 盤上の駒の名前一覧(保存用)
      #   to_s_battlers # => ["５五飛"]
      def to_s_battlers
        @battlers.collect(&:formal_name).sort.join(" ")
      end

      # boardに描画する
      def render_battlers
        @battlers.each do |battler|
          put_on_with_valid(battler)
        end
      end
    end

    # これどうなん？
    # SkillMonitor 側にもっていけばいいんじゃね？
    concerning :SkillMonitorMethods do
      attr_accessor :skill_set

      delegate :attack_infos, :defense_infos, to: :skill_set

      def skill_set
        @skill_set ||= SkillSet.new
      end

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

    # # 持駒を配置してみた状態にする(FIXME: これは不要になったのでテストも不要かも)
    def safe_put_on(arg, &block)
      _save = marshal_dump
      execute(arg)
      if block
        yield self
      end
      marshal_load(_save)
      # shash = Soldier.from_str(arg)
      # _battler = Battler.new(shash.merge(player: self))
      # get_errors(shash[:point], shash[:piece], shash[:promoted]).each{|error|raise error}
      # begin
      #   @battlers << _battler
      #   put_on_with_valid(shash[:point], battler)
      #   if block
      #     yield battler
      #   end
      # ensure
      #   battler = board.pick_up!(shash[:point])
      #   @pieces << _battler.piece
      #   @battlers.pop
      # end
    end

    def put_on_with_valid(battler, **options)
      options = {
        validate: true,
      }.merge(options)

      if options[:validate]
        soldier = battler.to_soldier
        if s = find_collisione_pawn(soldier)
          raise DoublePawnError, "二歩です。すでに#{s.mark_with_formal_name}があるため#{battler}が打てません\n#{board_with_pieces}"
        end
        if dead_piece?(soldier)
          raise DeadPieceRuleError, "#{soldier.to_s.inspect} は死に駒です。「#{soldier}成」の間違いの可能性があります\n#{board_with_pieces}"
        end
      end

      board.put_on(battler.point, battler)
    end

    # 二歩でも行き止まりでもない？
    def rule_valid?(soldier)
      !find_collisione_pawn(soldier) && !dead_piece?(soldier)
    end

    # # モジュール化
    # begin
    #   def create_memento
    #     # board → battler → player の結び付きで戻ってくる(？) 要確認
    #     Marshal.dump([@location, @pieces, board])
    #   end
    #
    #   def restore_memento(memento)
    #     @location, @pieces, board = Marshal.load(memento)
    #   end
    # end

    private

    # 死に駒
    def dead_piece?(soldier)
      !Movabler.alive_piece?(soldier)
    end

    # 二歩？
    def find_collisione_pawn(soldier)
      if soldier.piece.key == :pawn && !soldier.promoted
        pawns_on_board(soldier.point).first
      end
    end

    # 縦列の自分の歩たちを取得
    def pawns_on_board(point)
      board.vertical_pieces(point.x).find_all do |e| # FIXME: find でいい
        e.player == self && e.piece.key == :pawn && !e.promoted
      end
    end

    def movable_infos(soldier)
      Movabler.movable_infos(self, soldier)
    end
  end
end
