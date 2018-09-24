module Warabi
  class YomikataInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "同",   yomikata: "どう",   },
      { key: "左",   yomikata: "ひだり", },
      { key: "右",   yomikata: "みぎ",   },
      { key: "直",   yomikata: "ちょく", },
      { key: "上",   yomikata: "うえ",   },
      { key: "引",   yomikata: "ひく",   },
      { key: "寄",   yomikata: "よる",   },
      { key: "成",   yomikata: "なり",   },
      { key: "不成", yomikata: "ふなり", },
      { key: "打",   yomikata: "うつ",   },
    ]
  end
end
