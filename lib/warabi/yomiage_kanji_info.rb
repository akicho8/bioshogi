module Warabi
  class YomiageKanjiInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "同",   yomiage: "同、",   },
      { key: "左",   yomiage: "左",     },
      { key: "右",   yomiage: "右",     },
      { key: "直",   yomiage: "ちょく", },
      { key: "上",   yomiage: "上",     },
      { key: "引",   yomiage: "引く",   },
      { key: "寄",   yomiage: "寄る",   },
      { key: "成",   yomiage: "成り",   },
      { key: "不成", yomiage: "不成",   },
      { key: "打",   yomiage: "打つ",   },
    ]
  end
end
