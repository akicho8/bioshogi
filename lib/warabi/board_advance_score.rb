# frozen-string-literal: true

module Warabi
  class BoardAdvanceScore
    include ApplicationMemoryRecord
    memory_record [
      { key: [:king,   false], weight_list: [    0,    0,    0,  -10,  300,  600,  900, 1200, 1200, ], },
      { key: [:rook,   false], weight_list: [    2,    1,   -5,    0,    0,    0,   10,   11,   12, ], },
      { key: [:bishop, false], weight_list: [    0,    0,    0,    0,    0,    0,   10,   11,   12, ], },
      { key: [:gold,   false], weight_list: [    2,    2,    1,   -1,    0,    0,    2,    2,    1, ], },
      { key: [:silver, false], weight_list: [    0,    1,    1,    1,    2,    1,    2,    2,    1, ], },
      { key: [:knight, false], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:lance,  false], weight_list: [    8,    7,    6,    5,    4,    3,    2,    1,    0, ], },
      { key: [:pawn,   false], weight_list: [    0,    0,    0,    1,    3,   15,   15,   15,    0, ], },

      { key: [:rook,    true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:bishop,  true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:silver,  true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:knight,  true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:lance,   true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
      { key: [:pawn,    true], weight_list: [    0,    0,    0,    0,    0,    0,    0,    0,    0, ], },
    ]
  end
end
