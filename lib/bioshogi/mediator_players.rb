# frozen-string-literal: true

module Bioshogi
  concern :MediatorPlayers do
    class_methods do
      def start
        new.tap do |e|
          e.placement_from_preset("平手")
        end
      end
    end

    attr_reader :players

    def players
      @players ||= Location.collect do |e|
        Player.new(mediator: self, location: e)
      end
    end

    def player_at(location)
      players[Location.fetch(location).code]
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

    def piece_box_clear
      players.collect { |e| e.piece_box.clear }
    end

    # def basic_score
    #   evaluator.basic_score
    # end

    # 互いに王手されている局面はありえない
    def position_invalid?
      players.all?(&:mate_advantage?)
    end

    concerning :Other do
      def pieces_set(str)
        Piece.s_to_h2(str).each do |location_key, counts|
          player_at(location_key).piece_box.set(counts)
        end
      end
    end

    concerning :TurnMethods do
      attr_writer :turn_info

      def turn_info
        @turn_info ||= TurnInfo.new
      end
    end

    concerning :PieceCountCheckMethods do
      # 全体の駒を一つに集める
      def to_piece_box
        piece_box = PieceBox.new
        piece_box = players.inject(piece_box) { |a, e| a.add(e.piece_box) }
        piece_box.add(board.to_piece_box)
      end

      # 足りない駒が入っている箱を返す
      def not_enough_piece_box
        all = PieceBox.all_in_create
        all.safe_sub(to_piece_box)
      end
    end
  end
end
