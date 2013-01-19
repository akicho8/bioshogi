# -*- coding: utf-8 -*-
#
# 全体管理
#
module Bushido
  class Frame
    attr_reader :players, :board

    def self.basic_instance
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

    def to_s
      s = ""
      s << @board.to_s(:kakiki)
      s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.pieces_compact_str}"}.join("\n") + "\n"
      s
    end
  end

  class LiveFrame < Frame
    attr_reader :count, :a_move_logs, :a_move_logs2

    def self.testcase3(params = {})
      basic_instance.tap do |o|
        (params[:init] || []).each_with_index{|init, index|o.players[index].initial_put_on(init)}
        o.execute(params[:exec])
      end
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

    # N手目のN
    def counter_human_name
      @count.next
    end

    def inspect
      "#{counter_human_name}:#{white_or_black}\n#{super}"
    end

    def white_or_black
      white_or_black_mark + (current_index.zero? ? "先手番" : "後手番")
    end

    def white_or_black_mark
      current_index.zero? ? "▲" : "▽"
    end

    def best_score
    end

    private

    def current_player(diff = 0)
      players[current_index(diff)]
    end

    def current_index(diff = 0)
      (@count + diff).modulo(@players.size)
    end
  end
end
