# frozen-string-literal: true

module Warabi
  concern :MediatorPlayers do
    class_methods do
      def start
        new.tap do |e|
          e.board.placement_from_preset
        end
      end
    end

    def players
      @players ||= Location.collect do |e|
        Player.new(mediator: self, location: e)
      end
    end

    def player_at(location)
      @players[Location.fetch(location).index]
    end

    def current_player(diff = 0)
      players[turn_info.current_location(diff).code]
    end

    def opponent_player
      current_player(1)
    end

    def next_player
      opponent_player
    end

    def win_player
      opponent_player
    end

    def lose_player
      current_player
    end

    # def piece_plot
    #   @players.each(&:piece_plot)
    # end

    def piece_box_clear
      @players.collect { |e| e.piece_box.clear }
    end

    concerning :Other do
      def pieces_set(str)
        Piece.s_to_h2(str).each do |location_key, counts|
          player_at(location_key).piece_box.set(counts)
        end
      end
    end

    concerning :TurnMethods do
      def turn_info
        @turn_info ||= TurnInfo.new
      end
    end
  end
end
