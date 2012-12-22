# -*- coding: utf-8 -*-

module Bushido
  class Frame
    attr_accessor :players, :board

    def self.setup
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

    def piece_discard
      @players.collect(&:piece_discard)
    end

    def inspect
      s = ""
      s << @board.to_kif_table
    end
  end

  class LiveFrame < Frame
    attr_accessor :count

    def initialize(*)
      super
      @count = 0
    end

    def next_scene
      @count += 1
    end

    def execute
    end
  end
end
