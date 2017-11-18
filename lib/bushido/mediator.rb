#
# 全体管理
#
module Bushido
  class Mediator
    concerning :PlayerSelector do
      class_methods do
        # 先手後手が座った状態で開始
        def start
          mediator = new
          mediator.players.each(&:pieces_add)
          mediator
        end
      end

      attr_accessor :players, :counter

      alias turn_max counter

      def initialize
        super
        @players = Location.collect do |e|
          Player.new(self, location: e)
        end
        @counter = 0
      end

      # def player_join(player)
      #   @players << player
      #   player.mediator = self
      #   player.board = @board
      # end

      def player_at(location)
        @players[Location[location].index]
      end

      def black_player; player_at(:black); end
      def white_player; player_at(:white); end

      alias player_b black_player
      alias player_w white_player

      # 相手プレイヤーを返す
      def reverse_player
        current_player(+1)
      end

      # 手番のプレイヤー
      def current_player(diff = 0)
        players[current_index(diff)]
      end

      def current_index(diff = 0)
        (@counter + diff).modulo(@players.size)
      end

      # プレイヤーたちの持駒から平手用の盤面の準備
      def piece_plot
        @players.collect(&:piece_plot)
      end

      # プレイヤーたちの持駒を捨てる
      def pieces_clear
        @players.collect(&:pieces_clear)
      end

      # def pieces_add
      #   @players.each(&:pieces_add)
      # end

      # N手目のN
      def counter_human_name
        @counter.next
      end
    end

    concerning :Boardable do
      included do
        attr_reader :board
      end

      class_methods do
      end

      def initialize
        super
        @board = Board.new
      end

      def board_reset(name = nil)
        Utils.board_reset_args(name).each do |location, v|
          player_at(location).initial_soldiers(v, from_piece: false)
        end
      end
    end

    concerning :Other do
      # 両者の駒の配置を決める
      # @example 持駒から配置する場合(持駒がなければエラーになる)
      #   initial_soldiers("▲３三歩 △１一歩")
      # @example 持駒から配置しない場合(無限に駒が置ける)
      #   initial_soldiers("▲３三歩 △１一歩", from_piece: false)
      def initial_soldiers(str, options = {})
        Utils.initial_soldiers_split(str).each do |info|
          player_at(info[:location]).initial_soldiers(info[:input], options)
        end
      end

      # 一般の持駒表記で両者に駒を配る
      # @example
      #   mediator.pieces_set("▲歩2 飛 △歩二飛 ▲金")
      def pieces_set(str)
        Utils.triangle_hold_pieces_str_to_hash(str).each do |location, pieces_str|
          player_at(location).pieces_set(pieces_str)
        end
      end
    end

    concerning :Executer do
      included do
        attr_reader :counter, :hand_logs
      end

      def initialize(*)
        super
        @hand_logs = []
      end

      # 棋譜入力
      def execute(str)
        Array.wrap(str).each do |str|
          if str == "投了"
            break
          end
          current_player.execute(str)
          @counter += 1
        end
      end

      # player.execute の直後に呼んで保存する
      def log_stock(player)
        @hand_logs << player.runner.hand_log
      end

      # 互換性用
      if true
        def kif_hand_logs; hand_logs.collect { |e| e.to_s_kif(with_mark: false) }; end
        def ki2_hand_logs; hand_logs.collect { |e| e.to_s_ki2(with_mark: true) }; end
      end

      def to_s
        s = ""
        s << "#{counter_human_name}手目: #{current_player.location.mark_with_name}番" + "\n"
        s << to_hand
        s
      end

      def inspect
        to_s
      end

      def to_hand
        s = ""
        s << @board.to_s
        s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.to_s_pieces}"}.join("\n") + "\n"
        s
      end

      def judgment_message
        "まで#{@counter}手で#{reverse_player.location.name}の勝ち"
      end
    end

    concerning :Serialization do
      class_methods do
        def from_dump(object)
          new.tap do |o|
            o.replace(object)
          end
        end
      end

      # TODO: Player の marshal_dump が使われてない件について調べる
      def marshal_dump
        {
          counter: @counter,
          players: @players,
          hand_logs: @hand_logs,
        }
      end

      def marshal_load(attrs)
        @counter  = attrs[:counter]
        @players  = attrs[:players]
        @hand_logs = attrs[:hand_logs]
        @board = Board.new
        @players.each { |player| player.mediator = self }
        @players.collect { |player| player.render_soldiers }
      end

      # deep_dup しておくこと
      def replace(object)
        @counter = object.counter
        @players = object.players
        @hand_logs = object.hand_logs
        @board = Board.new
        @players.each { |player| player.mediator = self }
        @players.collect { |player| player.render_soldiers }
        self
      end

      def deep_dup
        Marshal.load(Marshal.dump(self))
      end

      # サンドボックス実行用
      def sandbox_for(&block)
        stack_push
        begin
          yield self
        ensure
          stack_pop
        end
      end
    end

    concerning :HistoryStack do
      def initialize(*)
        super
        @stack = []
      end

      def stack_push
        @stack.push(Marshal.dump(self))
      end

      def stack_pop
        if @stack.empty?
          raise HistroyStackEmpty
        end
        bin = @stack.pop
        replace(Marshal.load(bin))
      end
    end

    concerning :Variables do
      attr_reader :variables, :var_stack

      def initialize(*)
        super
        @variables = {}
        @var_stack = Hash.new([])
      end

      def set(key, value)
        @variables[key] = value
      end

      def get(key)
        @variables[key]
      end

      def marshal_dump
        super.merge(variables: @variables, var_stack: @var_stack)
      end

      def marshal_load(attrs)
        super
        @variables = attrs[:variables]
        @var_stack = attrs[:var_stack]
      end

      def var_push(key)
        @var_stack[key] << @variables[key]
      end

      def var_pop(key)
        @variables[key] = @var_stack[key].pop
      end
    end

    concerning :Textie do
      def to_text
        out = []
        out << "-" * 40 + "\n"
        out << "棋譜: #{ki2_hand_logs.join(" ")}\n"
        out << variables.inspect + "\n"
        out << to_hand
        out.join.strip
      end
    end
  end

  concern :MediatorTestHelper do
    class_methods do
      def test(params = {})
        params = {
          nplayers: 2,
          # sim: false,
        }.merge(params)

        # if params[:sim]
        #   mediator = new
        # else
        #   mediator = start
        # end
        mediator = start
        mediator.players = mediator.players.first(params[:nplayers])
        if params[:init]
          mediator.initial_soldiers(params[:init])
        end
        if params[:init2]
          mediator.initial_soldiers(params[:init2], from_piece: false)
        end
        if params[:pinit]
          mediator.pieces_set(params[:pinit])
        end
        if params[:pieces_clear]
          mediator.pieces_clear
        end
        mediator.execute(params[:exec])
        mediator
      end

      # mediator = Mediator.simple_test(init: "▲１二歩", pinit: "▲歩")
      # mediator = Mediator.simple_test(init: "▲３三歩 △１一歩")
      # mediator = Mediator.simple_test(init: "▲１三飛 △１一香 △１二歩")
      # mediator = Mediator.simple_test(init: "▲１六香 ▲１七飛 △１二飛 △１三香 △１四歩")
      def simple_test(params = {})
        params = {
        }.merge(params)
        new.tap do |o|
          o.initial_soldiers(params[:init], from_piece: false)
          o.pieces_set(params[:pinit])
        end
      end

      def test2(params = {})
        start.tap do |o|
          Utils.ki2_parse(params[:exec]).each do |op|
            player = o.players[Location[op[:location]].index]
            player.execute(op[:input])
          end
        end
      end
    end
  end

  class SimulatorFrame < Mediator
    def initialize(pattern)
      super()
      @pattern = pattern

      # Location.each{|loc|
      #   player_join(Player.new(location: loc))
      # }

      board_reset(@pattern[:board])

      if @pattern[:pieces]
        Location.each do |loc|
          players[loc.index].pieces_add(@pattern[:pieces][loc.key])
        end
      end
    end

    def build_frames(&block)
      frames = []
      frames << deep_dup
      if block
        yield frames.last
      end
      Utils.ki2_parse(@pattern[:execute]).each do |op|
        if op.kind_of?(String)
          raise SyntaxDefact, op
        end
        player_at(op[:location]).execute(op[:input])
        frames << deep_dup
        if block
          yield frames.last
        end
      end
      frames
    end
  end

  # FIXME: pattern をこの中に入れたらどうなる？
  class Sequencer < Mediator
    attr_reader :frames
    attr_accessor :pattern
    attr_accessor :instruction_pointer

    def initialize(pattern = nil)
      super()
      @pattern = pattern
      @frames = []
      @instruction_pointer = 0

      # if @pattern[:board]
      #   board_reset(@pattern[:board])
      # end

      # Location.each{|loc|
      #   player_join(Player.new(location: loc))
      # }
    end

    def pattern=(block)
      if block.kind_of? Proc
        @pattern = KifuDsl.define(&block)
      else
        @pattern = block
      end
    end

    def evaluate
      @pattern.evaluate(self)
    end

    def eval_step
      expr = nil
      loop do
        expr = @pattern.seqs[@instruction_pointer]
        unless expr
          break
        end
        @instruction_pointer += 1
        expr.evaluate(self)
        if expr.kind_of?(KifuDsl::Mov)
          break
        end
      end
      expr
    end
  end

  class HybridSequencer
    def self.execute(pattern)
      if pattern[:dsl]
        mediator = Sequencer.new
        mediator.pattern = pattern[:dsl]
        mediator.evaluate
        mediator.frames
      else
        mediator = SimulatorFrame.new(pattern)
        # mediator.build_frames{|e|p e}
        mediator.build_frames
      end
    end
  end
end
