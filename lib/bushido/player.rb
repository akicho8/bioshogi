# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/player_spec.rb" -*-

module Bushido
  class Player
    # FIXME: deal と pieces がかぶっている
    def self.basic_test(params = {})
      params = {
        :player => :black,
      }.merge(params)

      player = Player.new(:location => params[:player], :board => Board.new, :deal => true)

      # 最初にくばるオプション(追加で)
      player.deal(params[:deal])

      player.initial_soldiers(params[:init])
      if params[:piece_plot]
        player.piece_plot
      end

      Array.wrap(params[:exec]).each{|v|player.execute(v)}

      # あとでくばる(というかセットする)
      if params[:pieces]
        player.piece_discard
        player.deal(params[:pieces])
      end

      player
    end

    def self.basic_test2(params = {})
      basic_test(params).soldier_names.sort
    end

    attr_accessor :name, :board, :location, :frame, :last_piece, :parsed_info, :moved_point

    def initialize(params = {})
      super() if defined? super
      if v = params[:location]
        self.location = v
      end
      if v = params[:board]
        @board = v
      end
      if v = params[:deal]
        deal
      end
    end

    def marshal_dump
      {
        :name         => @name,
        :moved_point  => @moved_point,
        :location     => @location,
        :last_piece   => @last_piece,
        :pieces       => @pieces.collect(&:sym_name),
        :soldiers     => @soldiers.collect(&:formality_name2),
      }
    end

    def marshal_load(attrs)
      @name        = attrs[:name]
      @moved_point = attrs[:moved_point]
      @location    = attrs[:location]
      @last_piece  = attrs[:last_piece]
      @pieces      = attrs[:pieces].collect{|v|Piece[v]}
      @soldiers = attrs[:soldiers].collect{|soldier|
        Soldier.new(Utils.parse_str(soldier).merge(:player => self))
      }
    end

    # 先手後手を設定は適当でいい
    #   player.location = :white
    #   player.location = "後手"
    def location=(key)
      @location = Location[key]
    end

    # 平手の初期配置
    def piece_plot
      Utils.initial_placements_for(location).each{|info|
        pick_out(info[:piece])
        soldier = Soldier.new(info.merge(:player => self))
        put_on_with_valid(info[:point], soldier)
        @soldiers << soldier
      }
    end

    # 持駒の配置
    #   持駒は無限にあると考えて自由に初期配置を作りたい場合は from_piece:false にすると楽ちん
    #   player.initial_soldiers(["５五飛", "３三飛"], :from_piece => false)
    #   player.initial_soldiers("#{point}馬")
    #   player.initial_soldiers({:point => point, :piece => Piece["角"], :promoted => true}, :from_piece => false)
    def initial_soldiers(arg, options = {})
      options = {
        :from_piece => true, # 持駒から配置する？
      }.merge(options)
      Array.wrap(arg).each{|arg|
        if Hash === arg
          info = arg
        else
          if arg.to_s.gsub(/_/, "").blank? # テストを書きやすくするため
            next
          end
          info = Utils.parse_str(arg)
        end
        if options[:from_piece]
          pick_out(info[:piece]) # 持駒から引くだけでそのオブジェクトを打つ必要はない
        end
        soldier = Soldier.new(info.merge(:player => self))
        put_on_with_valid(info[:point], soldier)
        @soldiers << soldier
      }
    end

    # # 盤上の自分の駒
    # def soldiers
    #   @soldiers
    #   # @ @board.surface.values.find_all{|soldier|soldier.player == self}
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

        _soldier = @board.fetch(a)
        if _soldier.promoted?
          raise AlredyPromoted, "#{_soldier.point.name}の#{_soldier.piece.name}はすでに成っています"
        end
      end

      soldier = @board.pick_up!(a)
      target_soldier = @board.fetch(b)
      if target_soldier
        if target_soldier.player == self
          raise SamePlayerSoldierOverwrideError, "移動先の#{b.name}に自分の#{target_soldier.formality_name}があります"
        end
        @board.pick_up!(b)
        @pieces << target_soldier.piece
        @last_piece = target_soldier.piece
        target_soldier.player.soldiers.delete(target_soldier)
      end

      if promote_trigger
        soldier.promoted = true
      end

      put_on_with_valid(b, soldier)
    end

    # 前の位置(同に使う)
    def point_logs
      if @frame
        @frame.point_logs
      end
    end

    # 棋譜の入力
    def execute(str)
      if str == "投了"
        return
      end
      @parsed_info = OrderParser.new(self).execute(str)
      @moved_point = @parsed_info.point
    end

    # def moved_point
    #   if @parsed_info
    #     @parsed_info.point
    #   end
    # end

    def inspect
      [("-" * 40), super, board_with_pieces, ("-" * 40)].join("\n")
    end

    # 盤面と持駒(表示用)
    def board_with_pieces
      s = ""
      s << @board.to_s
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
        piece_fetch(piece) or raise PieceNotFound, "持駒に#{piece.name}がありません\n#{board_with_pieces}"
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
      def piece_discard
        @pieces.clear
      end

      # 配布して持駒にする
      #
      #   player = Player.new
      #   player.deal("飛 歩二")
      #   player.to_s_pieces # => "飛 歩二"
      #
      def deal(str = Utils.first_distributed_pieces)
        @pieces += Utils.stand_parse(str)
      end

      # 持駒を文字列化したものをインポートする(未使用)
      #   player.import_from_s_pieces("歩九 角 飛 香二 桂二 銀二 金二 玉")
      def import_from_s_pieces(str)
        @pieces = Utils.stand_parse(str)
      end

      # 持駒の文字列化
      #   Player.basic_test.to_s_pieces # => "歩九 角 飛 香二 桂二 銀二 金二 玉"
      def to_s_pieces
        pieces.group_by{|e|e.class}.collect{|klass, pieces|
          count = ""
          if pieces.size > 1
            count = pieces.size.to_s.tr("0-9", "〇一二三四五六七八九")
          end
          "#{pieces.first.name}#{count}"
        }.join(SEPARATOR)
      end
    end

    # 盤上の駒関連
    module Soldierable
      extend ActiveSupport::Concern

      included do
        attr_accessor :soldiers
      end

      module ClassMethods
      end

      def initialize(*)
        super
        @soldiers = []
      end

      # 盤上の駒の名前一覧(表示・デバッグ用)
      #   soldier_names # => ["▽5五飛↓"]
      def soldier_names
        @soldiers.collect(&:formality_name).sort
      end

      # 盤上の駒の名前一覧(保存用)
      #   to_s_soldiers # => ["5五飛"]
      def to_s_soldiers
        @soldiers.collect(&:formality_name2).sort.join(" ")
      end

      # @boardに描画する
      def render_soldiers
        @soldiers.each{|soldier|
          put_on_with_valid(soldier.point, soldier)
        }
      end
    end

    def evaluate
      Evaluate.new(self).evaluate
    end

    def generate_way
      _generate_way.generate_way
    end

    def _generate_way
      GenerateWay.new(self)
    end

    # # 持駒を配置してみた状態にする(FIXME: これは不要になったのでテストも不要かも)
    # def safe_put_on(arg, &block)
    #   info = parse_str(arg)
    #   _soldier = Soldier.new2(self, pick_out(info[:piece]), info[:promoted])
    #   get_errors(info[:point], info[:piece], info[:promoted]).each{|error|raise error}
    #   begin
    #     @soldier << _soldier
    #     put_on_with_valid(info[:point], soldier)
    #     if block
    #       yield soldier
    #     end
    #   ensure
    #     soldier = @board.pick_up!(info[:point])
    #     @pieces << _soldier.piece
    #     @soldier.pop
    #   end
    # end

    # 二歩？
    def double_pawn?(point, piece, promoted)
      if piece.sym_name == :pawn && !promoted
        pawns_on_board(point).first
      end
    end

    # 縦列の自分の歩たちを取得
    def pawns_on_board(point)
      soldiers = @board.pieces_of_vline(point.x)
      soldiers = soldiers.find_all{|s|s.player == self}
      soldiers = soldiers.find_all{|s|!s.promoted?}
      soldiers = soldiers.find_all{|s|s.piece.sym_name == :pawn}
      soldiers
    end

    def put_on_with_valid(point, soldier, options = {})
      options = {
        :validate => true,
      }.merge(options)
      if options[:validate]
        get_errors(point, soldier.piece, soldier.promoted).each{|error|raise error}
      end
      @board.put_on(point, soldier)
    end

    def get_errors(point, piece, promoted)
      errors = []
      if s = double_pawn?(point, piece, promoted)
        errors << DoublePawn.new("二歩です。#{s.formality_name}があるため#{point.name}に#{piece.name}は打てません")
      end
      if moveable_points(point, piece, promoted, :board_object_collision_skip => true).empty?
        errors << NotPutInPlaceNotBeMoved.new("#{piece.some_name(promoted)}を#{point.name}に置いてもそれ以上動かせないので反則です")
      end
      errors
    end

    # # モジュール化
    # begin
    #   def create_memento
    #     # @board → soldier → player の結び付きで戻ってくる(？) 要確認
    #     Marshal.dump([@location, @pieces, @board])
    #   end
    #
    #   def restore_memento(memento)
    #     @location, @pieces, @board = Marshal.load(memento)
    #   end
    # end

    private

    def moveable_points(point, piece, promoted, options = {})
      Movabler.moveable_points(self, point, piece, promoted, options)
    end

    # def side_soldiers_put_on(table)
    #   table.each{|info|initial_soldiers(info)}
    # end

    include Pieceable
    include Soldierable
  end

  # 形勢判断
  class Evaluate
    def initialize(player)
      @player = player
    end

    def evaluate
      score = 0

      score += @player.soldiers.collect{|soldier|
        if soldier.promoted?
          {:pawn => 1200, :bishop => 2000, :rook => 2200, :lance => 1200, :knight => 1200, :silver => 1200}[soldier.piece.sym_name]
        else
          {:pawn => 100, :bishop => 1800, :rook => 2000, :lance => 600, :knight => 700, :silver => 1000, :gold => 1200, :king => 9999}[soldier.piece.sym_name]
        end
      }.reduce(:+) || 0

      score += @player.pieces.collect{|piece|
        {:pawn => 105, :bishop => 1890, :rook => 2100, :lance => 630, :knight => 735, :silver => 1050, :gold => 1260, :king => 9999}[piece.sym_name]
      }.reduce(:+) || 0

      score
    end
  end

  class GenerateWay
    def initialize(player)
      @player = player
    end

    def generate_way
      all_ways.sample
    end

    def all_ways
      soldiers_ways + pieces_ways
    end

    # 盤上の駒の全手筋
    def soldiers_ways
      list = []

      mpoints = @player.soldiers.collect{|soldier|
        soldier.moveable_points.collect{|point|{:soldier => soldier, :point => point}}
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
          if @player.get_errors(point, piece, false).empty?
            list << [point.name, piece.name, "打"].join
          end
        end
      end
      list
    end
  end
end
