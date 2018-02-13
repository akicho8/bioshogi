# frozen-string-literal: true

module Warabi
  concern :MediatorPlayers do
    class_methods do
      def start
        new.tap do |e|
          e.board.set_from_preset_key
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

    def flip_player
      current_player(1)
    end

    def next_player
      flip_player
    end

    def win_player
      flip_player
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
      def soldier_create(str, **options)
        InputParser.scan(str).each do |str|
          soldier = Soldier.from_str(str)
          board.put_on(soldier)
        end
      end

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
