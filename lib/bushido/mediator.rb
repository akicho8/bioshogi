# frozen-string-literal: true
#
# 全体管理
#
module Bushido
  class Mediator
    concerning :ConfigMethods do
      attr_accessor :config

      def config
        @config ||= {
          defense_form_check_skip: false,
        }
      end
    end

    concerning :PlayerSelector do
      class_methods do
        # 先手後手が座った状態で開始
        def start
          mediator = new
          mediator.players.each(&:pieces_add)
          mediator
        end
      end

      attr_accessor :players

      def initialize
        super
        @players = Location.collect do |e|
          Player.new(self, location: e)
        end
        # @turn_info = 0
      end

      # def player_join(player)
      #   @players << player
      #   player.mediator = self
      #   player.board = @board
      # end

      def player_at(location)
        @players[Location[location].index]
      end

      def black_player
        player_at(:black)
      end

      def white_player
        player_at(:white)
      end

      alias player_b black_player
      alias player_w white_player

      # 相手プレイヤーを返す
      def reverse_player
        current_player(+1)
      end

      # 手番のプレイヤー
      def current_player(diff = 0)
        players[turn_info.current_location(diff).code]
      end

      def next_player
        current_player(1)
      end

      # プレイヤーたちの持駒から平手用の盤面の準備
      def piece_plot
        @players.each(&:piece_plot)
      end

      # プレイヤーたちの持駒を捨てる
      def pieces_clear
        @players.collect(&:pieces_clear)
      end

      # def pieces_add
      #   @players.each(&:pieces_add)
      # end

      # N手目のN
      # def counter_human_name
      #   @counter.next
      # end

      private
    end

    # concerning :TebanMethods do
    #   included do
    #   end
    #
    #   def initialize
    #     super
    #   end
    # end

    concerning :BoardMethods do
      included do
        attr_reader :board
        attr_accessor :turn_info
      end

      class_methods do
      end

      def initialize
        super
        @board = Board.new
        @turn_info = TurnInfo.new("平手")
      end

      # DEPRECATION
      def board_reset_old(v)
        case
        when BoardParser.accept?(v)
          board_reset_by_shape(v)
        when v.kind_of?(Hash)
          board_reset_for_hash(v)
        else
          board_reset(v)
        end
      end

      def board_reset(name = nil)
        raise MustNotHappen if BoardParser.accept?(name)

        # if name == "その他"
        #   name = nil
        # end

        name = name.presence || "平手"

        # @turn_info = TurnInfo.new(name)

        # "角落ち" なら {"▲" => "角落ち", "△" => "平手"}
        v = {black: "平手", white: "平手"}
        if name != "平手"
          # 駒落ちの場合△の方が駒を落とす
          # 呼び方も△が「上手」になる。先に指すことになるので「後手」と呼んでいると意味が通じなくなる
          v[:white] = name
        end

        board_reset_for_hash(v)

        @turn_info = TurnInfo.new(board.teaiwari_name)
      end

      def board_reset_by_shape(value)
        raise MustNotHappen unless BoardParser.accept?(value)
        v = BoardParser.parse(value).both_board_info
        board_reset5(v)
        # このあと自分で手合割を決めること。次のようにする
        # mediator.turn_info = TurnInfo.new(mediator.board.teaiwari_name)

        # if board.teaiwari_name
        #   @turn_info = TurnInfo.new(board.teaiwari_name)
        # else
        #   # 手合いが不明なものは何か落ち
        #   # @turn_info = TurnInfo.new("落")
        # end
      end

      # 盤面から手合割を判断する
      def board_reset_by_shape2
        if board.teaiwari_name
          @turn_info = TurnInfo.new(board.teaiwari_name)
        end
      end

      def board_reset_for_hash(v)
        v = v.inject({}) {|a, (k, v)|
          a.merge(Location[k] => Utils.location_soldiers(location: k, key: v))
        }
        board_reset5(v)
      end

      def board_reset5(v)
        v.each do |location, v|
          player_at(location).battlers_create(v, from_stand: false)
        end
      end

      def turn_max
        turn_info.counter
      end

    end

    concerning :Other do
      # 両者の駒の配置を決める
      # @example 持駒から配置する場合(持駒がなければエラーになる)
      #   battlers_create("▲３三歩 △１一歩")
      # @example 持駒から配置しない場合(無限に駒が置ける)
      #   battlers_create("▲３三歩 △１一歩", from_stand: false)
      def battlers_create(str, **options)
        Utils.initial_battlers_split(str).each do |info|
          player_at(info[:location]).battlers_create(info[:input], options)
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
        attr_reader :hand_logs
      end

      def initialize(*)
        super
        @hand_logs = []
      end

      # 棋譜入力
      def execute(str)
        Array.wrap(str).each do |str|

          # ▲△があれば見て手番と一致しているか確認する
          # なければチェックしなくていい
          if true
            if md = str.match(Runner.input_regexp)
              if key = md[:sankaku] || md[:plus_or_minus]
                location = Location.fetch(key)
                unless current_player.location == Location.fetch(key)
                  raise DifferentTurnError, "#{current_player.call_name}番で#{reverse_player.call_name}が着手しました : #{str}"
                end
              end
            end
          end

          current_player.execute(str)
          turn_info.counter += 1
        end
      end

      # player.execute の直後に呼んで保存する
      def hand_log_push(player)
        @hand_logs << player.runner.hand_log
      end

      # 互換性用
      if true
        def kif_hand_logs; hand_logs.collect { |e| e.to_s_kif(with_mark: false) }; end
        def ki2_hand_logs; hand_logs.collect { |e| e.to_s_ki2(with_mark: true) }; end
      end

      # TODO: bod フォーマットとする
      def to_s
        s = []
        s << white_player.hold_pieces_snap + "\n"
        s << @board.to_s
        s << black_player.hold_pieces_snap + "\n"

        last = ""
        if hand_log = hand_logs.last
          last = hand_log.to_s_kif(with_mark: true)
        end

        s << "手数＝#{turn_info.counter} #{last} まで".squish + "\n"

        # これいる？ → いる
        if true
          if current_player.location.key == :white # ← 判定が違う気がす
            s << "\n"
            s << "#{current_player.call_name}番\n"
          end
        end

        s.join
      end

      def inspect
        to_s
      end

      def to_hand
        s = []
        s << @board.to_s
        s << @players.collect { |player|
          "#{player.call_name}の持駒:#{player.to_s_pieces}"
        }.join("\n") + "\n"
        s.join
      end

      def judgment_message
        "まで#{turn_info.counter}手で#{reverse_player.call_name}の勝ち"
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
          turn_info: turn_info,
          players: @players,
          hand_logs: @hand_logs,
        }
      end

      def marshal_load(attrs)
        @turn_info  = attrs[:turn_info]
        @players  = attrs[:players]
        @hand_logs = attrs[:hand_logs]
        @board = Board.new
        @players.each { |player| player.mediator = self }
        @players.collect { |player| player.render_battlers }
      end

      # deep_dup しておくこと
      def replace(object)
        @turn_info = object.turn_info
        @players = object.players
        @hand_logs = object.hand_logs
        @board = Board.new
        @players.each { |player| player.mediator = self }
        @players.collect { |player| player.render_battlers }
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
          mediator.battlers_create(params[:init])
        end
        if params[:init2]
          mediator.battlers_create(params[:init2], from_stand: false)
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
          o.battlers_create(params[:init], from_stand: false)
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

  module HybridSequencer
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
