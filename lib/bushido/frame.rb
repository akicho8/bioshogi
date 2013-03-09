# -*- coding: utf-8 -*-
#
# 全体管理
#
module Bushido
  module PlayerSelector
    extend ActiveSupport::Concern

    included do
      attr_reader :players, :counter
    end

    module ClassMethods
      # 先手後手が座った状態で開始
      def start
        new.tap do |o|
          Location.each{|loc|
            player = Player.new(:location => loc)
            player.deal
            o.player_join(player)
          }
        end
      end
    end

    def initialize
      super
      @players = []
      @counter = 0
    end

    def player_join(player)
      @players << player
      player.frame = self
      player.board = @board
    end

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
  end

  module Serialization
    def marshal_dump
      {
        :counter      => @counter,
        :players    => @players,
        :simple_kif_logs   => @simple_kif_logs,
        :humane_kif_logs   => @humane_kif_logs,
        :point_logs => @point_logs,
      }
    end

    def marshal_load(attrs)
      @counter      = attrs[:counter]
      @players    = attrs[:players]
      @simple_kif_logs   = attrs[:simple_kif_logs]
      @humane_kif_logs   = attrs[:humane_kif_logs]
      @point_logs = attrs[:point_logs]
      @board = Board.new
      @players.each{|player|
        player.board = @board
        player.frame = self
      }
      @players.collect{|player|
        player.render_soldiers
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end
  end

  module HistoryStack
    def initialize(*)
      super
      @stack = []
    end

    def stack_push
      @stack.push(deep_dup)
    end

    def stack_pop
      if app = @stack.pop
        marshal_load(app.marshal_dump)
      end
    end
  end

  module Executer
    extend ActiveSupport::Concern

    included do
      attr_reader :counter, :simple_kif_logs, :humane_kif_logs, :point_logs
    end

    module ClassMethods
      def testcase3(params = {})
        params = {
          :nplayers => 2,
        }.merge(params)

        object = new
        params[:nplayers].times do |i|
          player = Player.new
          player.location = Location[i]
          player.deal
          object.player_join(player)
        end
        (params[:init] || []).each_with_index{|init, index|object.current_player(index).initial_soldiers(init)}
        object.execute(params[:exec])
        object
      end
    end

    def initialize(*)
      super
      @point_logs = []
      @simple_kif_logs = []
      @humane_kif_logs = []
    end

    # 棋譜入力
    def execute(str)
      Array.wrap(str).each do |str|
        if str == "投了"
          return
        end
        current_player.execute(str)
        log_stock(current_player)
        @counter += 1
      end
    end

    # player.execute の直後に呼んで保存する
    def log_stock(player)
      @point_logs << player.parsed_info.point
      @simple_kif_logs << "#{player.location.mark}#{player.parsed_info.last_kif}"
      @humane_kif_logs << "#{player.location.mark}#{player.parsed_info.last_ki2}"
    end

    def inspect
      "#{counter_human_name}手目: #{current_player.location.mark_with_name}番\n#{super}"
    end

    def to_s
      s = ""
      s << @board.to_s
      s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.to_s_pieces}"}.join("\n") + "\n"
      s
    end
  end

  class BasicFrame
    include PlayerSelector
    include Boardable
    include Executer
    include Serialization
    include HistoryStack
  end

  class Frame < BasicFrame
  end

  class LiveFrame < Frame
  end

  class SimulatorFrame < LiveFrame

    def initialize(pattern)
      super()
      @pattern = pattern

      Location.each{|loc|
        player_join(Player.new(:location => loc))
      }

      if @pattern[:board].blank? || @pattern[:board] == :default
        board_info = {}
        Location.each{|loc|
          board_info[loc.key] = Utils.initial_placements_for(loc)
        }
      elsif @pattern[:board].in?([:white, :black])
        board_info = {}
        loc = Location[@pattern[:board]]
        board_info[loc.key] = Utils.initial_placements_for(loc)
      else
        board_info = BaseFormat.board_parse(@pattern[:board])
      end

      Location.each{|loc|
        players[loc.index].initial_soldiers(board_info[loc.key], :from_piece => false)
      }

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
          player = players[Location[op[:location]].index]
          player.execute(op[:input])
          log_stock(player)
          frames << deep_dup
          if block
            yield frames.last
          end
        end
      }
      frames
    end
  end
end
