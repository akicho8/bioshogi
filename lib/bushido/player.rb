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
      if v = params[:deal]
        deal
      end
    end

    def board
      @mediator.board
    end

    def next_player
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
      # location_soldiers2 = location_soldiers[location.key]
      location_soldiers.each{|info|
        pick_out(info[:piece])
        soldier = Soldier.new(info.merge(player: self))
        put_on_with_valid(info[:point], soldier)
        @soldiers << soldier
      }
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_piece:false にすると楽ちん
    #   player.initial_soldiers(["５五飛", "３三飛"], from_piece: false)
    #   player.initial_soldiers("#{point}馬")
    #   player.initial_soldiers({point: point, piece: Piece["角"], promoted: true}, from_piece: false)
    def initial_soldiers(mini_soldier_or_str, options = {})
      options = {
        from_piece: true, # 持駒から配置する？
      }.merge(options)
      Array.wrap(mini_soldier_or_str).each{|mini_soldier_or_str|
        if String === mini_soldier_or_str
          if mini_soldier_or_str.to_s.gsub(/_/, "").empty? # テストを書きやすくするため
            next
          end
          mini_soldier = MiniSoldier.from_str(mini_soldier_or_str)
        else
          mini_soldier = mini_soldier_or_str
        end
        if options[:from_piece]
          pick_out(mini_soldier[:piece]) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        soldier = Soldier.new(mini_soldier.merge(player: self))
        put_on_with_valid(mini_soldier[:point], soldier)
        @soldiers << soldier
      }
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
          raise NotPromotable, "#{a.name}から#{b.name}への移動では成れません"
        end

        _soldier = board.fetch(a)
        if _soldier.promoted?
          raise AlredyPromoted, "#{_soldier.point.name}の#{_soldier.piece.name}はすでに成っています"
        end
      end

      soldier = board.pick_up!(a)
      target_soldier = board.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.mark_with_formal_name}があります"
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
    module Pieceable
      extend ActiveSupport::Concern

      included do
        attr_accessor :pieces
      end

      module ClassMethods
      end

      def initialize(*)
        super
        @pieces = []
      end

      # 必ず存在する持駒を参照する
      def piece_fetch!(piece)
        piece_fetch(piece) or raise PieceNotFound, "持駒に#{piece.name}がない\n#{board_with_pieces}"
      end

      # 持駒を参照する
      def piece_fetch(piece)
        @pieces.find{|e|e.class == piece.class}
      end

      # 持駒を取り出す
      def pick_out(piece)
        piece_fetch!(piece)
        if index = @pieces.find_index{|e|e.class == piece.class}
          @pieces.slice!(index)
        end
      end

      # 持駒の名前一覧(表示・デバッグ用)
      def piece_names
        pieces.collect(&:name).sort
      end

      # 持駒を捨てる
      def pieces_clear
        @pieces.clear
      end

      # 配布して持駒にする
      #
      #   player = Player.new
      #   player.deal("飛 歩二")
      #   player.to_s_pieces # => "飛 歩二"
      #
      def deal(str = "歩9角飛香2桂2銀2金2玉")
        @pieces += Utils.hold_pieces_str_to_array(str)
      end

      def reset_pieces_from_str(str)
        @pieces = Utils.hold_pieces_str_to_array(str)
      end

      # 持駒を文字列化したものをインポートする(未使用)
      #   player.import_from_s_pieces("歩九 角 飛 香二 桂二 銀二 金二 玉")
      def import_from_s_pieces(str)
        @pieces = Utils.hold_pieces_str_to_array(str)
      end

      # 持駒の文字列化
      #   Player.basic_test.to_s_pieces # => "歩九 角 飛 香二 桂二 銀二 金二 玉"
      def to_s_pieces
        Utils.hold_pieces_array_to_str(pieces)
      end
    end

    # 盤上の駒関連
    module Soldierable
      extend ActiveSupport::Concern

      included do
        attr_accessor :soldiers, :complete_defense_names
      end

      module ClassMethods
      end

      def initialize(*)
        super
        # インスタンス変数は何もしなければ自動的に Marshal の対象になる
        @soldiers = []
        @complete_defense_names = []
        @defense_name_append = false
      end

      # 盤上の駒の名前一覧(表示・デバッグ用)
      #   soldier_names # => ["▽5五飛↓"]
      def soldier_names
        @soldiers.collect(&:mark_with_formal_name).sort
      end

      # 盤上の駒の名前一覧(保存用)
      #   to_s_soldiers # => ["5五飛"]
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
        stocks = Stock.list.find_all{|v|(v[:size_type] || :x99) == size_type}
        stocks = stocks.find_all{|v|v[:defense_p] || v[:attack_p]}

        # ここがかなり重い
        stocks.collect{|stock|
          placements = Utils.both_soldiers_from_char_board2(location: location, stock: stock)
          a = placements.values.flatten.collect(&:to_s)
          b = board.surface.values.collect(&:to_h).collect(&:to_s)
          match_p = (a - b).empty?
          {key: stock[:key], placements: placements, match: match_p}
        }
      end
    end

    def evaluate
      Evaluate.new(self).evaluate
    end

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
      if mini_soldier[:piece].sym_name == :pawn && !mini_soldier[:promoted]
        pawns_on_board(mini_soldier[:point]).first
      end
    end

    # 縦列の自分の歩たちを取得
    def pawns_on_board(point)
      soldiers = board.pieces_of_vline(point.x)
      soldiers = soldiers.find_all{|s|s.player == self}
      soldiers = soldiers.find_all{|s|!s.promoted?}
      soldiers = soldiers.find_all{|s|s.piece.sym_name == :pawn}
      soldiers
    end

    def put_on_with_valid(point, soldier, options = {})
      options = {
        validate: true,
      }.merge(options)
      if options[:validate]
        get_errors(soldier.to_mini_soldier.merge(point: point)).each{|error|raise error}
      end
      board.put_on(point, soldier)
    end

    def get_errors(mini_soldier)
      errors = []
      if s = find_collisione_pawn(mini_soldier)
        errors << DoublePawn.new("二歩 (#{s.mark_with_formal_name}があるため#{mini_soldier}が打てない)")
      end
      if Movabler.movable_infos2(self, mini_soldier).empty?
        errors << NotPutInPlaceNotBeMoved.new(self, "#{mini_soldier}はそれ以上動かせないので反則")
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

    private

    # def side_soldiers_put_on(table)
    #   table.each{|info|initial_soldiers(info)}
    # end

    include Pieceable
    include Soldierable
  end
end
