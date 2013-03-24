# -*- coding: utf-8 -*-
#
# 全体管理
#
module Bushido
  module PlayerSelector
    extend ActiveSupport::Concern

    included do
      attr_accessor :players, :counter
    end

    module ClassMethods
      # 先手後手が座った状態で開始
      def start
        mediator = new
        mediator.players.each{|player|player.deal}
        mediator
      end
    end

    def initialize
      super
      @players = Location.collect{|loc|Player.new(self, :location => loc)}
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

    # 前後のプレイヤーを返す
    def prev_player; current_player(-1); end
    def next_player; current_player(+1); end

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
    def piece_discard
      @players.collect(&:piece_discard)
    end

    # def deal
    #   @players.each(&:deal)
    # end

    # N手目のN
    def counter_human_name
      @counter.next
    end
  end

  module Boardable
    extend ActiveSupport::Concern

    included do
      attr_reader :board
    end

    module ClassMethods
    end

    def initialize
      super
      @board = Board.new
    end

    def board_reset(name = nil)
      hash = Utils.board_init_type(name)
      hash.each{|k, v|
        player_at(k).initial_soldiers(v, :from_piece => false)
      }
    end
  end

  module Serialization
    extend ActiveSupport::Concern

    module ClassMethods
      def from_dump(object)
        o = new
        o.replace(object)
        o
      end
    end

    # TODO: Player の marshal_dump が使われてない件について調べる
    def marshal_dump
      {
        :counter  => @counter,
        :players  => @players,
        :kif_logs => @kif_logs,
      }
    end

    def marshal_load(attrs)
      @counter  = attrs[:counter]
      @players  = attrs[:players]
      @kif_logs = attrs[:kif_logs]
      @board = Board.new
      @players.each{|player|
        player.mediator = self
      }
      @players.collect{|player|
        player.render_soldiers
      }
    end

    # deep_dup しておくこと
    def replace(object)
      @counter  = object.counter
      @players  = object.players
      @kif_logs = object.kif_logs
      @board = Board.new
      @players.each{|player|
        player.mediator = self
      }
      @players.collect{|player|
        player.render_soldiers
      }
      self
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    # サンドボックス実行用
    def sandbox_for(&block)
      stack_push
      begin
        if block_given?
          yield self
        end
      ensure
        stack_pop
      end
    end
  end

  module HistoryStack
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

  module Executer
    extend ActiveSupport::Concern

    included do
      attr_reader :counter, :kif_logs
    end

    def initialize(*)
      super
      @kif_logs = []
    end

    # 棋譜入力
    def execute(str)
      Array.wrap(str).each do |str|
        if str == "投了"
          return
        end
        current_player.execute(str)
        @counter += 1
      end
    end

    # player.execute の直後に呼んで保存する
    def log_stock(player)
      @kif_logs << player.runner.kif_log
    end

    # 互換性用
    if true
      def simple_kif_logs; kif_logs.collect{|e|e.to_s_simple(:with_mark => true)}; end
      def human_kif_logs;  kif_logs.collect{|e|e.to_s_human(:with_mark => true)};  end
    end

    def to_s
      s = ""
      s << "#{counter_human_name}手目: #{current_player.location.mark_with_name}番" + "\n"
      s << @board.to_s
      s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.to_s_pieces}"}.join("\n") + "\n"
      s
    end
  end

  module MediatorTestHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def test(params = {})
        params = {
          :nplayers => 2,
        }.merge(params)
        mediator = start
        mediator.players = mediator.players.first(params[:nplayers])
        (params[:init] || []).each_with_index{|init, index|mediator.current_player(index).initial_soldiers(init)}
        mediator.execute(params[:exec])
        mediator
      end

      def test2(params = {})
        mediator = start
        Utils.ki2_input_seq_parse(params[:exec]).each{|op|
          player = mediator.players[Location[op[:location]].index]
          player.execute(op[:input])
        }
        mediator
      end
    end
  end

  class Mediator
    include PlayerSelector
    include Boardable
    include Executer
    include Serialization
    include HistoryStack
  end

  class SimulatorFrame < Mediator
    def initialize(pattern)
      super()
      @pattern = pattern

      # Location.each{|loc|
      #   player_join(Player.new(:location => loc))
      # }

      board_reset(@pattern[:board])

      if @pattern[:pieces]
        Location.each{|loc|
          players[loc.index].deal(@pattern[:pieces][loc.key])
        }
      end
    end

    def to_all_frames(&block)
      frames = []
      frames << deep_dup
      if block
        yield frames.last
      end
      Utils.ki2_input_seq_parse(@pattern[:execute]).each{|op|
        if op == "push"
          stack_push
        elsif op == "pop"
          stack_pop
        else
          # p op
          player = players[Location[op[:location]].index]
          player.execute(op[:input])
          frames << deep_dup
          if block
            yield frames.last
          end
        end
      }
      frames
    end
  end

  # FIXME: pattern をこの中に入れたらどうなる？
  class Sequencer < Mediator
    attr_reader :frames, :variables
    attr_accessor :pattern

    def initialize(pattern = nil)
      super()
      @pattern = pattern
      @frames = []
      @variables = {}
      @instruction_pointer = 0

      # Location.each{|loc|
      #   player_join(Player.new(:location => loc))
      # }
    end

    def set(key, value)
      @variables[key] = value
    end

    def get(key)
      @variables[key]
    end

    def marshal_dump
      super.merge(:variables => @variables)
    end

    def marshal_load(attrs)
      super
      @variables = attrs[:variables]
    end

    def evaluate
      @pattern.evaluate(self)
    end

    def eval_step
      loop do
        expr = @pattern.seqs[@instruction_pointer]
        @instruction_pointer += 1
        unless expr
          break
        end
        expr.evaluate(self)
        if KifuDsl::Mov === expr
          break
        end
      end
    end
  end
end
