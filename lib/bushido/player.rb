# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-
# -*- frozen-string-literal: false -*-

module Bushido
  class Player
    attr_accessor :name
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
      mini_soldiers = Utils.location_mini_soldiers(location: location, key: "平手")
      mini_soldiers.each do |mini_soldier|
        piece_pick_out(mini_soldier[:piece])
        soldiers_create_from_mini_soldier(mini_soldier)
      end
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_stand:false にすると楽ちん
    #   player.soldiers_create(["５五飛", "３三飛"], from_stand: false)
    #   player.soldiers_create("#{point}馬")
    #   player.soldiers_create({point: point, piece: Piece["角"], promoted: true}, from_stand: false)
    def soldiers_create(mini_soldier_or_str, options = {})
      options = {
        from_stand: true, # 持駒から取り出して配置する？
      }.merge(options)

      Array.wrap(mini_soldier_or_str).each do |mini_soldier_or_str|
        if mini_soldier_or_str.kind_of?(String)
          if mini_soldier_or_str.to_s.gsub(/_/, "").empty? # テストを書きやすくするため
            next
          end
          mini_soldier = MiniSoldier.from_str(mini_soldier_or_str)
        else
          mini_soldier = mini_soldier_or_str
        end
        if options[:from_stand]
          piece_pick_out(mini_soldier[:piece]) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        soldiers_create_from_mini_soldier(mini_soldier)
      end
    end

    # # 盤上の自分の駒
    # def soldiers
    #   @soldiers
    #   # @ board.surface.values.find_all{|soldier|soldier.player == self}
    # end

    # 盤上の駒を from から to に移動する。成るなら promote_trigger を有効に。
    def move_to(from, to, promote_trigger = false)
      @last_piece_taken_from_opponent = nil # 最後に取った駒 FIXME:名前がだめ

      from = Point.parse(from)
      to = Point.parse(to)

      if promote_trigger
        if !from.promotable?(location) && !to.promotable?(location)
          raise NotPromotable, "成りを入力しましたが #{from.name} から #{to.name} への移動では成れません"
        end

        soldier = board.lookup(from)
        if soldier.promoted?
          raise AlredyPromoted, "成りを入力しましたが #{soldier.point.name} の #{soldier.piece.name} はすでに成っています"
        end
      end

      from_soldier = board.pick_up!(from)

      # 移動先に相手の駒があれば取って駒台に移動する
      to_soldier = board.lookup(to)
      if to_soldier
        if to_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の #{to.name} には自分の駒 #{to_soldier.mark_with_formal_name.inspect} があります"
        end
        board.pick_up!(to)
        @pieces << to_soldier.piece
        @last_piece_taken_from_opponent = to_soldier.piece
        to_soldier.player.soldiers.delete(to_soldier)
      end

      if promote_trigger
        from_soldier.promoted = true
      end

      raise MustNotHappen unless location == from_soldier.location
      from_soldier.point = to
      put_on_with_valid(from_soldier)
    end

    # # # 前の位置(同に使う)
    # def point_logs
    #   @mediator.point_logs
    # end

    # 棋譜の入力
    def execute(str)
      if str == "投了"
        return
      end
      @runner = Runner.new(self).execute(str)
      defense_form_store
      @mediator.log_stock(self)
    end

    def inspect
      [("-" * 40), super, board_with_pieces, ("-" * 40)].join("\n")
    end

    # 盤面と持駒(表示用)
    def board_with_pieces
      s = ""
      s << board.to_s
      s << "#{hold_pieces_snap}\n"
      s
    end

    # 持駒関連
    # ここは駒台クラスとして一段下げる方法もある
    concerning :Pieceable do
      included do
        attr_accessor :pieces
      end

      def initialize(*)
        super
        @pieces = []
      end

      # # 必ず存在する持駒を参照する
      # def piece_fetch(piece)
      #   piece_lookup(piece) or raise PieceNotFound, "持駒に #{piece.name.inspect} がありません\n#{board_with_pieces}"
      # end

      # 持駒を参照する
      def piece_lookup(piece)
        @pieces.find { |e| e.key == piece.key }
      end

      # 持駒を取り出す
      def piece_pick_out(piece)
        index = @pieces.find_index { |e| e.key == piece.key }
        index or raise HoldPieceNotFound, "持駒に #{piece.name.inspect} がありません\n#{board_with_pieces}"
        @pieces.slice!(index)
      end

      # 持駒の名前一覧(表示・デバッグ用)
      def piece_names
        @pieces.collect(&:name).sort
      end

      # 持駒を捨てる
      def pieces_clear
        @pieces.clear
      end

      # 配布して持駒にする
      #
      #   player = Player.new
      #   player.pieces_add("飛 歩二")
      #   player.to_s_pieces # => "飛 歩二"
      #
      def pieces_add(str = "歩9角飛香2桂2銀2金2玉")
        @pieces += Utils.hold_pieces_s_to_a(str)
      end

      # 持駒表記変換 (コード → 人間表記)
      #   pieces_set("歩2 飛") # => [Piece["歩"], Piece["歩"], Piece["飛"]]
      def pieces_set(str)
        @pieces = Utils.hold_pieces_s_to_a(str)
      end

      # 持駒の文字列化
      #   Player.basic_test.to_s_pieces # => "歩九 角 飛 香二 桂二 銀二 金二 玉"
      def to_s_pieces
        Utils.hold_pieces_a_to_s(@pieces)
      end

      def hold_pieces_snap
        "#{location.name}の持駒：#{to_s_pieces.presence || "なし"}"
      end
    end

    # 盤上の駒関連
    concerning :SoldierMethods do
      included do
        attr_accessor :soldiers, :complete_defense_names
      end

      def initialize(*)
        super
        # インスタンス変数は何もしなければ自動的に Marshal の対象になる
        @soldiers = []
        @complete_defense_names = []
        @defense_name_append = false
      end

      def soldiers_create_from_mini_soldier(mini_soldier)
        soldier = Soldier.new(mini_soldier.merge(player: self))
        put_on_with_valid(soldier)
        @soldiers << soldier
      end

      # 盤上の駒の名前一覧(表示・デバッグ用)
      #   soldier_names # => ["△５五飛↓"]
      def soldier_names
        @soldiers.collect(&:mark_with_formal_name).sort
      end

      # 盤上の駒の名前一覧(保存用)
      #   to_s_soldiers # => ["５五飛"]
      def to_s_soldiers
        @soldiers.collect(&:formal_name).sort.join(" ")
      end

      # boardに描画する
      def render_soldiers
        @soldiers.each do |soldier|
          put_on_with_valid(soldier)
        end
      end

      def defense_form_store
        @defense_name_append = false
        defense_form_keys.each do |key|
          unless @complete_defense_names.include?(key)
            @complete_defense_names << key
            @defense_name_append = true
          end
        end
      end

      def defense_name_append?
        !!@defense_name_append
      end

      def defense_form_keys
        defense_form_infos.find_all{|e|e[:match]}.collect{|e|e[:key]}
      end

      def defense_form_infos
        unless Bushido.config[:defense_form_check]
          return []
        end

        # # ここがかなり重い
        # StaticBoardInfo.collect do |static_board_info|
        #   placements = Utils.board_point_realize(location: location, both_board_info: static_board_info.both_board_info)
        #   a = placements.values.flatten.collect(&:to_s)
        #   b = board.surface.values.collect(&:to_mini_soldier).collect(&:to_s)
        #   match_p = (a - b).empty?
        #   {key: static_board_info.key, placements: placements, match: match_p}
        # end

        []
      end
    end

    def evaluator
      Evaluator.new(self)
    end

    delegate :evaluate, :score_percentage, to: :evaluator

    def brain
      Brain.new(self)
    end

    # # 持駒を配置してみた状態にする(FIXME: これは不要になったのでテストも不要かも)
    def safe_put_on(arg, &block)
      _save = marshal_dump
      execute(arg)
      if block
        yield self
      end
      marshal_load(_save)
      # shash = MiniSoldier.from_str(arg)
      # _soldier = Soldier.new(shash.merge(player: self))
      # get_errors(shash[:point], shash[:piece], shash[:promoted]).each{|error|raise error}
      # begin
      #   @soldiers << _soldier
      #   put_on_with_valid(shash[:point], soldier)
      #   if block
      #     yield soldier
      #   end
      # ensure
      #   soldier = board.pick_up!(shash[:point])
      #   @pieces << _soldier.piece
      #   @soldiers.pop
      # end
    end

    def put_on_with_valid(soldier, **options)
      options = {
        validate: true,
      }.merge(options)

      if options[:validate]
        mini_soldier = soldier.to_mini_soldier
        if s = find_collisione_pawn(mini_soldier)
          raise DoublePawn, "二歩 (#{s.mark_with_formal_name}があるため#{soldier}が打てません)"
        end
        if dead_piece?(mini_soldier)
          raise DeadPieceRuleError, "#{mini_soldier.to_s.inspect} は死に駒です。「#{mini_soldier}成」の間違いの可能性があります。\n#{@board}"
        end
      end

      board.put_on(soldier.point, soldier)
    end

    # 二歩でも行き止まりでもない？
    def rule_valid?(mini_soldier)
      !find_collisione_pawn(mini_soldier) && !dead_piece?(mini_soldier)
    end

    # # モジュール化
    # begin
    #   def create_memento
    #     # board → soldier → player の結び付きで戻ってくる(？) 要確認
    #     Marshal.dump([@location, @pieces, board])
    #   end
    #
    #   def restore_memento(memento)
    #     @location, @pieces, board = Marshal.load(memento)
    #   end
    # end

    private

    # 死に駒
    def dead_piece?(mini_soldier)
      Movabler.simple_movable_infos(self, mini_soldier).empty?
    end

    # 二歩？
    def find_collisione_pawn(mini_soldier)
      if mini_soldier[:piece].key == :pawn && !mini_soldier[:promoted]
        pawns_on_board(mini_soldier[:point]).first
      end
    end

    # 縦列の自分の歩たちを取得
    def pawns_on_board(point)
      board.vertical_pieces(point.x).find_all do |e|
        e.player == self && e.piece.key == :pawn && !e.promoted
      end
    end

    def movable_infos(mini_soldier, **options)
      Movabler.movable_infos(self, mini_soldier, options)
    end

    # def side_soldiers_put_on(table)
    #   table.each{|info|soldiers_create(info)}
    # end
  end
end
