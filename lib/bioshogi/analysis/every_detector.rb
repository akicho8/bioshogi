# frozen-string-literal: true

module Bioshogi
  module Analysis
    class EveryDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "駒柱",
          func: -> {
            # 【条件】今の場所の列が埋まっている
            and_cond { board.column_soldier_counter.filled?(soldier.place.column) }
          },
        },
      ]
    end
  end
end
