# frozen-string-literal: true

module Warabi
  concern :MediatorBoard do
    def board
      @board ||= Board.new
    end

    delegate :board_set_any, :set_from_preset_key, :set_from_hash, :set_from_hash, to: :board

    def set_from_soldiers(soldiers)
      board.set_from_soldiers(soldiers)
      play_standby
    end
  end
end
