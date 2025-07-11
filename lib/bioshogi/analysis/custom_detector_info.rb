module Bioshogi
  module Analysis
    class CustomDetectorInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "穴熊判定",         klass: AnagumaDetector,      custom_trigger_key: :ct_every,  },
        { key: "入玉穴熊判定",     klass: NyuugyokuAnagumaDetector,     custom_trigger_key: :ct_every,  },
        { key: "双馬結界判定",         klass: HorseDetector,      custom_trigger_key: :ct_every,  },
        { key: "N段ロケット判定",  klass: RocketDetector,      custom_trigger_key: :ct_every,  },
        { key: "魔方陣判定",       klass: MagicSquareDetector, custom_trigger_key: :ct_every,  },
        { key: "角切り判定",       klass: KakukiriDetector,    custom_trigger_key: :ct_capture,  },
        { key: "飛角交換判定",       klass: KakukiriDetector2,    custom_trigger_key: :ct_capture,  },
        # { key: "角切り判定2",      klass: KakukiriDetector2,   custom_trigger_key: :ct_capture,  },
        # { key: "角切りキャンセル", klass: KakukiriCanceler,    custom_trigger_key: :ct_capture,  },
        { key: "開戦時の何か",     klass: OutbreakDetector,    custom_trigger_key: :ct_outbreak, },
      ]

      class << self
        def custom_trigger_keys_hash
          @custom_trigger_keys_hash ||= group_by(&:custom_trigger_key)
        end
      end
    end
  end
end
