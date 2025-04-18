# frozen-string-literal: true

# ▲△と混同しがちだが▲△は場所のことであって順番とは関係がない。
# たとえば駒落ちの場合は△から指すため「△=後手」と解釈しているとおかしくなる。

module Bioshogi
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :order_first,  name: "先手" }, # 奇数回に指す側
      { key: :order_second, name: "後手" }, # 偶数回に指す側
    ]
  end
end
