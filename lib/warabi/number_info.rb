module Warabi
  class NumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "1", yomikata: " 1 ",  },
      { key: "2", yomikata: "にー", },
      { key: "3", yomikata: " 3 ",  },
      { key: "4", yomikata: " 4 ",  },
      { key: "5", yomikata: "ごー", },
      { key: "6", yomikata: " 6 ",  },
      { key: "7", yomikata: " 7 ",  },
      { key: "8", yomikata: " 8 ",  },
      { key: "9", yomikata: " 9 ",  },
    ]
  end
end
