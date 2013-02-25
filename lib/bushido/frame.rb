# -*- coding: utf-8 -*-
#
# 全体管理
#
module Bushido
  module Serialization
    def marshal_dump
      {
        :count      => @count,
        :players    => @players,
        :kif_logs   => @kif_logs,
        :ki2_logs   => @ki2_logs,
        :last_point => @last_point,
      }
    end

    def marshal_load(attrs)
      @count      = attrs[:count]
      @players    = attrs[:players]
      @kif_logs   = attrs[:kif_logs]
      @ki2_logs   = attrs[:ki2_logs]
      @last_point = attrs[:last_point]
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

  class Frame
    attr_reader :players, :board

    # 先手後手が座った状態で開始
    def self.basic_instance
      new.tap do |o|
        o.player_join(Player.create1(:black))
        o.player_join(Player.create1(:white))
      end
    end

    # 盤面だけある状態で開始
    def initialize
      @board = Board.new
      @players = []
    end

    def player_join(player)
      @players << player
      player.frame = self
      player.board = @board
    end

    # def players_init
    #   @players.each{|player|
    #     player.frame = self
    #     player.board = @board
    #   }
    # end

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

    # 文字列表記
    def to_s
      s = ""
      s << @board.to_s
      s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.to_s_pieces}"}.join("\n") + "\n"
      s
    end
  end

  # 棋譜入力対応の全体管理
  class LiveFrame < Frame
    include Serialization
    attr_reader :count, :kif_logs, :ki2_logs, :last_point

    # テスト用
    def self.testcase3(params = {})
      basic_instance.tap do |o|
        (params[:init] || []).each_with_index{|init, index|o.players[index].initial_put_on(init)}
        o.execute(params[:exec])
      end
    end

    def initialize(*)
      super
      @count = 0
      @last_point = nil
      @kif_logs = []
      @ki2_logs = []
    end

    # 棋譜入力
    def execute(str)
      Array.wrap(str).each do |str|
        if str == "投了"
          return
        end
        current_player.execute(str)
        log_stock(current_player)
        @count += 1
      end
    end

    def log_stock(player)
      @last_point = player.parsed_info.point
      @kif_logs << "#{player.location.mark}#{player.parsed_info.last_kif}"
      @ki2_logs << "#{player.location.mark}#{player.parsed_info.last_ki2}"
    end

    # 前後のプレイヤーを返す
    def prev_player; current_player(-1); end
    def next_player; current_player(+1); end

    # N手目のN
    def counter_human_name
      @count.next
    end

    # 手番のプレイヤー
    def current_player(diff = 0)
      players[current_index(diff)]
    end

    def inspect
      "#{counter_human_name}手目: #{current_player.location.mark_with_name}番\n#{super}"
    end

    # def create_memento
    #   # @board, @players,
    #   object = [@count, @kif_logs, @ki2_logs]
    #   # [@board, @players, @count, @kif_logs, @ki2_logs]
    #   Marshal.dump(object)
    # end
    #
    # def restore_memento(object)
    #   @board, @players, @count, @kif_logs, @ki2_logs = Marshal.load(object)
    # end

    private

    def current_index(diff = 0)
      (@count + diff).modulo(@players.size)
    end
  end

  class LiveFrame2 < LiveFrame
    include HistoryStack

    def initialize(pattern)
      super()
      @pattern = pattern

      Location.each{|loc|
        player_join(Player.new(:location => loc))
      }

      if @pattern[:board].blank?
        board_info = {}
        Location.each{|loc|
          board_info[loc.key] = Utils.initial_placements_for(loc)
        }
      elsif @pattern[:board].in?([:white, :black])
        board_info = {}
        loc = Location[@pattern[:board]]
        board_info[loc.key] = Utils.initial_placements_for(loc)
      else
        board_info = BaseFormat::Parser.board_parse(@pattern[:board])
      end

      Location.each{|loc|
        players[loc.index].initial_put_on(board_info[loc.key], :from_piece => false)
      }

      if @pattern[:pieces]
        Location.each{|loc|
          players[loc.index].deal(@pattern[:pieces][loc.key])
        }
      end
    end

    def to_all_frames
      frames = []
      frames << deep_dup
      Utils.ki2_input_seq_parse(@pattern[:execute]).each{|hash|
        player = players[Location[hash[:location]].index]
        player.execute(hash[:input])
        log_stock(player)
        frames << deep_dup
      }
      frames
    end
  end
end
