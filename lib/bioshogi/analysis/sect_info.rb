# frozen-string-literal: true

module Bioshogi
  module Analysis
    class SectInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "居飛車",   },
        { key: "振り飛車", },
      ]
    end
  end
end
