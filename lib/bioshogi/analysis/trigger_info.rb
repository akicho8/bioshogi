# frozen-string-literal: true

module Bioshogi
  module Analysis
    class TriggerInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "玉飛接近",
          trigger_piece_key: [
            { piece_key: :rook, promoted: false, motion: :move },
            { piece_key: :king, promoted: false, motion: :move },
          ],
        },
        {
          key: "天空の城",
          trigger_piece_key: [
            { piece_key: :king,   promoted: false, motion: :move },
            { piece_key: :silver, promoted: :both, motion: :both },
            { piece_key: :gold,   promoted: false, motion: :both },
          ],
        },
      ]
    end
  end
end
