# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  class Player
    attr_accessor :name, :location, :mediator, :last_piece, :runner

    def initialize(mediator, params = {})
      super() if defined? super

      @mediator = mediator

      if v = params[:location]
        self.location = v
      end

      # if v = params[:board]
      #   @board = v
      # end

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
      location_soldiers = Utils.location_soldiers(location: location, key: "平手")
      location_soldiers.each do |info|
        piece_pick_out(info[:piece])
        soldier = Soldier.new(info.merge(player: self))
        put_on_with_valid(info[:point], soldier)
        @soldiers << soldier
      end
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_piece:false にすると楽ちん
    #   player.initial_soldiers(["５五飛", "３三飛"], from_piece: false)
    #   player.initial_soldiers("#{point}馬")
    #   player.initial_soldiers({point: point, piece: Piece["角"], promoted: true}, from_piece: false)
    def initial_soldiers(mini_soldier_or_str, options = {})
      options = {
        from_piece: true, # 持駒から取り出して配置する？
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

        # p mini_soldier
        # p options[:from_piece]

        if options[:from_piece]
          piece_pick_out(mini_soldier[:piece]) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        soldier = Soldier.new(mini_soldier.merge(player: self))
        put_on_with_valid(mini_soldier[:point], soldier)
        @soldiers << soldier
      end
    end

    # # 盤上の自分の駒
    # def soldiers
    #   @soldiers
    #   # @ board.surface.values.find_all{|soldier|soldier.player == self}
    # end

    # 盤上の駒を a から b に移動する。成るなら promote_trigger を有効に。
    def move_to(a, b, promote_trigger = false)
      @last_piece = nil

      a = Point.parse(a)
      b = Point.parse(b)

      if promote_trigger
        if a.promotable?(location) || b.promotable?(location)
        else
          raise NotPromotable, "#{a.name}から#{b.name}への移動では成れない"
        end

        _soldier = board.fetch(a)
        if _soldier.promoted?
          raise AlredyPromoted, "#{_soldier.point.name}の#{_soldier.piece.name}はすでに成っている"
        end
      end

      soldier = board.pick_up!(a)
      target_soldier = board.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.mark_with_formal_name}がある"
        end
        board.pick_up!(b)
        @pieces << target_soldier.piece
        @last_piece = target_soldier.piece
        target_soldier.player.soldiers.delete(target_soldier)
      end

      if promote_trigger
        soldier.promoted = true
      end

      put_on_with_valid(b, soldier)
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
      s << "#{location.mark_with_name}の持駒:#{to_s_pieces}\n"
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

      # 盤上の駒の名前一覧(表示・デバッグ用)
      #   soldier_names # => ["▽５五飛↓"]
      def soldier_names
        @soldiers.collect(&:mark_with_formal_name).sort
      end

      # 盤上の駒の名前一覧(保存用)
      #   to_s_soldiers # => ["５五飛"]
      def to_s_soldiers
        @soldiers.collect(&:to_s_formal_name).sort.join(" ")
      end

      # boardに描画する
      def render_soldiers
        @soldiers.each{|soldier|
          put_on_with_valid(soldier.point, soldier)
        }
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

        size_type = Board.size_type

        # x99の盤面だけに絞る
        static_board_infos = StaticBoardInfo.find_all{|v|(v[:size_type] || :x99) == size_type}
        static_board_infos = static_board_infos.find_all{|v|v[:defense_p] || v[:attack_p]}

        # ここがかなり重い
        static_board_infos.collect do |static_board_info|
          placements = Utils.both_soldiers_from_char_board2(location: location, board: static_board_info)
          a = placements.values.flatten.collect(&:to_s)
          b = board.surface.values.collect(&:to_h).collect(&:to_s)
          match_p = (a - b).empty?
          {key: static_board_info.key, placements: placements, match: match_p}
        end
      end
    end

    def evaluator
      Evaluate.new(self)
    end

    delegate :evaluate, :score_percentage, :to => :evaluator

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

    # 二歩？
    def find_collisione_pawn(mini_soldier)
      if mini_soldier[:piece].key == :pawn && !mini_soldier[:promoted]
        pawns_on_board(mini_soldier[:point]).first
      end
    end

    # 縦列の自分の歩たちを取得
    def pawns_on_board(point)
      soldiers = board.pieces_of_vline(point.x)
      soldiers = soldiers.find_all { |s| s.player == self }
      soldiers = soldiers.find_all { |s| !s.promoted? }
      soldiers = soldiers.find_all { |s| s.piece.key == :pawn }
    end

    def put_on_with_valid(point, soldier, options = {})
      options = {
        validate: true,
      }.merge(options)

      if options[:validate]
        get_errors(soldier.to_mini_soldier.merge(point: point)).each do |e|
          raise e
        end
      end

      board.put_on(point, soldier)
    end

    def get_errors(mini_soldier)
      errors = []
      if s = find_collisione_pawn(mini_soldier)
        errors << DoublePawn.new("二歩 (#{s.mark_with_formal_name}があるため#{mini_soldier}が打てません)")
      end
      if Movabler.simple_movable_infos(self, mini_soldier).empty?
        errors << NotPutInPlaceNotBeMoved.new(self, "#{mini_soldier.to_s.inspect} はそれ以上動かせないので反則です。「#{mini_soldier.to_s}成」の間違いの可能性があります。")
      end
      errors
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

    def movable_infos(mini_soldier, options = {})
      Movabler.movable_infos(self, mini_soldier, options)
    end

    # def side_soldiers_put_on(table)
    #   table.each{|info|initial_soldiers(info)}
    # end
  end
end
