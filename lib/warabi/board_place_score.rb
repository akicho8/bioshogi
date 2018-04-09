# frozen-string-literal: true

module Warabi
  class BoardPlaceScore
    include ApplicationMemoryRecord
    memory_record [
      {
        key: [:pawn, false] * "_",
        score_fields: [
          [  0,  0,  0,  0,  0,  0,  0,  0,  0, ],
          [  0,  0,  0,  0,  0,  0,  0,  0,  0, ],
          [  0,  0,  0,  0,  0,  0,  0,  0,  0, ],
          [  0,  0,  0,  0,  0,  0,  0, 12,  0, ],
          [  2,  4,  0,  4,  4,  4,  5, 11,  2, ],
          [  4,  0, 10,  3,  0,  3,  4, 10,  4, ],
          [  2,  2,  2,  2,  2,  2,  2,  2,  2, ],
          [  1,  1,  1,  1,  1,  1,  1,  1,  1, ],
          [  0,  0,  0,  0,  0,  0,  0,  0,  0, ],
        ],
      },
    ]
  end
end
