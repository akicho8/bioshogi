module Bioshogi
  module Analysis
    class CustomTriggerInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :ct_every,    name: "毎回",   },
        { key: :ct_outbreak, name: "開戦時", },
        { key: :ct_capture,  name: "キル時", },
      ]

      def custom_detector_infos
        @custom_detector_infos ||= CustomDetectorInfo.custom_trigger_keys_hash[key]
      end
    end
  end
end
