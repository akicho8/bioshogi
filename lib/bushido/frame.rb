# -*- coding: utf-8 -*-

module Bushido
  class Frame
    attr_accessor :players, :board

    def self.players_join
      new.tap do |o|
        o.player_join(Player.create1(:black))
        o.player_join(Player.create1(:white))
      end
    end

    def initialize
      @board = Board.new
      @players = []
    end

    def player_join(player)
      @players << player
      player.frame = self
      player.board = @board
    end

    def piece_plot
      @players.collect(&:piece_plot)
    end

    def piece_discard
      @players.collect(&:piece_discard)
    end

    # def deal
    #   @players.each(&:deal)
    # end

    def inspect
      s = ""
      s << @board.to_s(:kakiki)
      @players.each{|player|
        s << "#{player.location}の持駒:" + player.pieces.collect(&:name).join + "\n"
      }
      s
    end
  end

  class LiveFrame < Frame
    attr_reader :count, :a_move_logs, :a_move_logs2

    def self.testcase3(params = {})
      params = {
        # :init => [],
        # :piece_discard => false, # 持駒を捨てる？
      }.merge(params)
      frame = players_join
      (params[:init] || []).each_with_index{|init, index|frame.players[index].initial_put_on(init)}
      # if params[:piece_discard]
      #   frame.piece_discard
      # end
      frame.execute(params[:exec])
      frame
    end

    def initialize(*)
      super
      @count = 0
      @a_move_logs = []
      @a_move_logs2 = []
    end

    def execute(str)
      Array.wrap(str).each do |str|
        if str == "投了"
          return
        end
        current_player.execute(str)
        @a_move_logs << "#{white_or_black_mark}#{current_player.last_a_move}"
        @a_move_logs2 << "#{white_or_black_mark}#{current_player.last_a_move_kif2}"
        @count += 1
      end
    end

    def prev_player
      current_player(-1)
    end

    def current_player(diff = 0)
      players[current_index(diff)]
    end

    def current_index(diff = 0)
      (@count + diff).modulo(@players.size)
    end

    def counter_human_name
      @count.next
    end

    def inspect
      "#{counter_human_name}:#{white_or_black}\n#{super}"
    end

    def white_or_black
      if current_index.zero?
        "▲先手番"
      else
        "▽後手番"
      end
    end

    def white_or_black_mark
      if current_index.zero?
        "▲"
      else
        "▽"
      end
    end
  end
end
