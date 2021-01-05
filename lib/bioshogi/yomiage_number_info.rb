module Bioshogi
  class YomiageNumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "1", yomiage: "いち",   },
      { key: "2", yomiage: "にぃ",   },
      { key: "3", yomiage: "さん",   },
      { key: "4", yomiage: "よん",   },
      { key: "5", yomiage: "ごー",   },
      { key: "6", yomiage: "ろく",   },
      { key: "7", yomiage: "なな",   },
      { key: "8", yomiage: "はち",   },
      { key: "9", yomiage: "きゅう", },
    ]
  end
end
