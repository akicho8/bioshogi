module Bioshogi
  module Analysis
    class CustomDetectorInfo
      include ApplicationMemoryRecord
      memory_record [
        { klass: RocketDetector },
      ]
    end
  end
end
