# frozen-string-literal: true

module Warabi
  concern :MediatorBoard do
    included do
      attr_reader :board
      attr_reader :first_state_board_sfen
      attr_accessor :turn_info
    end

    def initialize(*)
      super

      @board = Board.new
      @turn_info = TurnInfo.new
    end

    def board_reset_any(v)
      case
      when BoardParser.accept?(v)
        board_reset_by_shape(v)
      when v.kind_of?(Hash)
        board_reset_by_hash(v)
      else
        board_reset(v)
      end
    end

    def board_reset(value = nil)
      board_reset_by_hash(white: value || "平手")
    end

    def board_reset_by_shape(str)
      board_reset_by_soldiers(BoardParser.parse(str).soldier_box)
    end

    def board_reset_by_hash(hash)
      board_reset_by_soldiers(Soldier.preset_soldiers(hash))
    end

    def board_reset_by_soldiers(soldiers)
      soldiers.each do |soldier|
        player_at(soldier.location).soldier_create(soldier, from_stand: false)
      end
      play_standby
    end

    def turn_max
      turn_info.counter
    end
  end
end
