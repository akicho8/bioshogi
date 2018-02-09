# frozen-string-literal: true
#
# 全体管理
#
module Warabi
  class Mediator
    concerning :ConfigMethods do
      def mediator_options
        @mediator_options ||= {
          # skill_set_flag: true,
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
      end

      def player_at(location)
        @players[Location[location].index]
      end

      def current_player(diff = 0)
        players[turn_info.current_location(diff).code]
      end

      def reverse_player
        current_player(1)
      end

      def next_player
        reverse_player
      end

      # プレイヤーたちの持駒から平手用の盤面の準備
      def piece_plot
        @players.each(&:piece_plot)
      end

      # プレイヤーたちの持駒を捨てる
      def piece_box_clear
        @players.collect { |e| e.piece_box.clear }
      end
    end

    concerning :BoardMethods do
      included do
        attr_reader :board
        attr_reader :first_state_board_sfen
        attr_accessor :turn_info
      end

      class_methods do
      end

      def initialize
        super
        @board = Board.new
        @turn_info = TurnInfo.new
      end

      def board_reset_any(v)
        case
        when BoardParser.accept?(v)
          board_reset_by_shape(v)
        when v.kind_of?(Hash)
          board_reset_by_hash(v)
        else
          board_reset(v)
        end
      end

      def board_reset(value = nil)
        board_reset_by_hash(white: value || "平手")
      end

      def board_reset_by_shape(str)
        board_reset_by_soldiers(BoardParser.parse(str).soldier_box)
      end

      def board_reset_by_hash(hash)
        board_reset_by_soldiers(Soldier.preset_soldiers(hash))
      end

      def board_reset_by_soldiers(soldiers)
        soldiers.each do |soldier|
          player_at(soldier.location).battlers_create(soldier, from_stand: false)
        end
        play_standby
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
        Piece.s_to_h2(str).each do |location_key, counts|
          player_at(location_key).piece_box.set(counts)
        end
      end
    end

    concerning :Executer do
      included do
        attr_reader :hand_logs
        attr_accessor :kill_counter
      end

      def initialize(*)
        super
        @hand_logs = []
        @kill_counter = 0
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
        s << player_at(:white).hold_pieces_snap + "\n"
        s << @board.to_s
        s << player_at(:black).hold_pieces_snap + "\n"

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

      def to_bod(**options)
        to_s
      end

      def inspect
        to_s
      end

      def to_hand
        s = []
        s << @board.to_s
        s << @players.collect { |player|
          "#{player.call_name}の持駒:#{player.piece_box.to_s}"
        }.join("\n") + "\n"
        s.join
      end

      def judgment_message
        "まで#{turn_info.counter}手で#{win_player.call_name}の勝ち"
      end

      def win_player
        reverse_player
      end

      def lose_player
        current_player
      end
    end

    concerning :CsaMethods do
      def to_csa(**options)
        s = []
        preset_name = board.preset_name
        if preset_name
          unless options[:oneline]
            s << "#{Parser::CsaParser.comment_char} 手合割:#{preset_name}" + "\n"
          end
        end
        if options[:board_expansion]
          s << board.to_csa
        else
          if preset_name == "平手"
            s << "PI" + "\n"
          else
            s << board.to_csa
          end
        end
        players.each do |player|
          if v = player.to_csa.presence
            s << v + "\n"
          end
        end
        s.join
      end
    end

    concerning :UsiMethods do
      def initialize(*)
        super
        play_standby
      end

      def play_standby
        # turn_info_auto_set
        @first_state_board_sfen = to_current_sfen # これはイケてない
      end

      # 平手で開始する直前の状態か？
      def startpos?
        board.preset_name == "平手" && players.all? { |e| e.pieces.empty? }
      end

      # 現在の局面
      def to_current_sfen
        if startpos?
          "startpos"
        else
          to_long_sfen
        end
      end

      def to_long_sfen
        s = []
        s << "sfen"
        s << board.to_sfen
        # p turn_info
        s << turn_info.current_location.to_sfen
        if players.all? { |e| e.pieces.empty? }
          s << "-"
        else
          s << players.collect(&:to_sfen).join
        end
        s << turn_info.counter.next
        s.join(" ")
      end

      # 最初から現在までの局面
      def to_sfen(**options)
        s = []
        s << "position"
        s << @first_state_board_sfen # 局面を文字列でとっておくのってなんか違う気がする
        if hand_logs.present?
          s << "moves"
          s.concat(hand_logs.collect(&:to_sfen))
        end
        s.join(" ")
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
          kill_counter: @kill_counter,
          first_state_board_sfen: @first_state_board_sfen,
          board: @board,
        }
      end

      def marshal_load(attrs)
        @turn_info  = attrs[:turn_info]
        @players  = attrs[:players]
        @hand_logs = attrs[:hand_logs]
        @kill_counter = attrs[:kill_counter]
        @first_state_board_sfen = attrs[:first_state_board_sfen]
        @board = attrs[:board]
        @players.each { |player| player.mediator = self }
      end

      # deep_dup しておくこと
      def replace(object)
        @turn_info = object.turn_info
        @players = object.players
        @hand_logs = object.hand_logs
        @kill_counter = object.kill_counter
        @board = object.board
        @players.each { |player| player.mediator = self }
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
