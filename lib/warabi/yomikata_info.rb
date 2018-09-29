module Warabi
  class YomikataInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "同",   yomikata: "同、",   },
      { key: "左",   yomikata: "左",     },
      { key: "右",   yomikata: "右",     },
      { key: "直",   yomikata: "ちょく", },
      { key: "上",   yomikata: "上",     },
      { key: "引",   yomikata: "引く",   },
      { key: "寄",   yomikata: "寄る",   },
      { key: "成",   yomikata: "成り",   },
      { key: "不成", yomikata: "不成",   },
      { key: "打",   yomikata: "打つ",   },
    ]
  end
end
