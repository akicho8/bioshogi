# frozen-string-literal: true

module Bioshogi
  module Analysis
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
