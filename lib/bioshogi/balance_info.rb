module Bioshogi
  class BalanceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "normal",   name: "通常戦",   },
      { key: "coaching", name: "指導対局", },
    ]
  end
end
