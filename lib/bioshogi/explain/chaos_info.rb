# frozen-string-literal: true

module Bioshogi
  module Explain
    class ChaosInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "急戦調力戦",
          if_cond: -> context {
            true
          },
        },
      ]
    end
  end
end
