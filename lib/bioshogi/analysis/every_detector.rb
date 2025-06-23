# frozen-string-literal: true

module Bioshogi
  module Analysis
    class EveryDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "駒柱",
          func: -> {
            and_cond do
              player.board.piller_cop.active?.tap do
                player.board.piller_cop.active = false
              end
            end
          },
        },
      ]
    end
  end
end
