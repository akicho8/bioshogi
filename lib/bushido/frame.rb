# -*- coding: utf-8 -*-
#
# 全体管理
#
module Bushido
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
      s << @board.to_s(:kakiki)
      s << @players.collect{|player|"#{player.location.mark_with_name}の持駒:#{player.pieces_compact_str}"}.join("\n") + "\n"
      s
    end
  end

  # 棋譜入力対応の全体管理
  class LiveFrame < Frame
    attr_reader :count, :kif_logs, :kif2_logs

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
      @kif_logs = []
      @kif2_logs = []
    end

    # 棋譜入力
    def execute(str)
      Array.wrap(str).each do |str|
        if str == "投了"
          return
        end
        current_player.execute(str)
        @kif_logs << "#{current_player.location.mark}#{current_player.parsed_info.last_kif}"
        @kif2_logs << "#{current_player.location.mark}#{current_player.parsed_info.last_kif2}"
        @count += 1
      end
    end

    # 前のプレイヤーを返す
    def prev_player
      current_player(-1)
    end

    # N手目のN
    def counter_human_name
      @count.next
    end

    def inspect
      "#{counter_human_name}手目: #{current_player.location.mark_with_name}番\n#{super}"
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
