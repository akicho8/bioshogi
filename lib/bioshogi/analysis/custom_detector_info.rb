module Bioshogi
  module Analysis
    class CustomDetectorInfo
      include ApplicationMemoryRecord
      memory_record [
        { klass: RocketDetector,   custom_trigger_key: :ct_every,    },
        { klass: OutbreakDetector, custom_trigger_key: :ct_outbreak, },
      ]

      class << self
        def custom_trigger_keys_hash
          @custom_trigger_keys_hash ||= group_by(&:custom_trigger_key)
        end
      end
    end
  end
end
