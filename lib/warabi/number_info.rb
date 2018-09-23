module Warabi
  class NumberInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "1", yomikata: "いち",   },
      { key: "2", yomikata: "にー",   },
      { key: "3", yomikata: "さん",   },
      { key: "4", yomikata: "よん",   },
      { key: "5", yomikata: "ごー",   },
      { key: "6", yomikata: "ろく",   },
      { key: "7", yomikata: "なな",   },
      { key: "8", yomikata: "はち",   },
      { key: "9", yomikata: "きゅー", },
    ]
  end
end
