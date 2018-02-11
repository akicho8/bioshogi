# frozen-string-literal: true

module Warabi
  concern :MediatorPlayers do
    class_methods do
      def start
        new.tap do |e|
          e.players.each(&:pieces_add)
        end
      end
    end

    attr_accessor :players

    def initialize(*args)
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

    def win_player
      reverse_player
    end

    def lose_player
      current_player
    end

    # プレイヤーたちの持駒から平手用の盤面の準備
    def piece_plot
      @players.each(&:piece_plot)
    end

    # プレイヤーたちの持駒を捨てる
    def piece_box_clear
      @players.collect { |e| e.piece_box.clear }
    end

    concerning :Other do
      # 両者の駒の配置を決める
      # @example 持駒から配置する場合(持駒がなければエラーになる)
      #   soldier_create("▲３三歩 △１一歩")
      # @example 持駒から配置しない場合(無限に駒が置ける)
      #   soldier_create("▲３三歩 △１一歩", from_stand: false)
      def soldier_create(str, **options)
        InputParser.scan(str).each do |str|
          soldier = Soldier.from_str(str)
          player_at(soldier.location).soldier_create(soldier, options)
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
  end
end
