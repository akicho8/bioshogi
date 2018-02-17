# frozen-string-literal: true

module Warabi
  concern :MediatorBoard do
    def board
      @board ||= Board.new
    end

    delegate :board_set_any, :placement_from_preset, :placement_from_hash, :placement_from_hash, to: :board

    def placement_from_soldiers(soldiers)
      board.placement_from_soldiers(soldiers)
      play_standby
    end
  end
end
