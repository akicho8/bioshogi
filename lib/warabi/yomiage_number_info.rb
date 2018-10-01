module Warabi
  class YomiageNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "1", yomiage: " 1 ",  },
      { key: "2", yomiage: "にー", },
      { key: "3", yomiage: " 3 ",  },
      { key: "4", yomiage: " 4 ",  },
      { key: "5", yomiage: "ごー", },
      { key: "6", yomiage: " 6 ",  },
      { key: "7", yomiage: " 7 ",  },
      { key: "8", yomiage: " 8 ",  },
      { key: "9", yomiage: " 9 ",  },
    ]
  end
end
