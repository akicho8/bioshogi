# frozen-string-literal: true

# ▲△とは関係がない
module Warabi
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      {key: :sente, name: "先手"}, # 奇数回に指す側
      {key: :gote,  name: "後手"}, # 偶数回に指す側
    ]
  end
end
