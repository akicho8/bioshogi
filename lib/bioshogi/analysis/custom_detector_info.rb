module Bioshogi
  module Analysis
    class CustomDetectorInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "穴熊判定",         custom_trigger_key: :ct_every,    klass: CustomDetectors::AnagumaDetector,          },
        { key: "入玉穴熊判定",     custom_trigger_key: :ct_every,    klass: CustomDetectors::NyuugyokuAnagumaDetector, },
        { key: "双馬結界判定",     custom_trigger_key: :ct_every,    klass: CustomDetectors::HorseDetector,            },
        { key: "N段ロケット判定",  custom_trigger_key: :ct_every,    klass: CustomDetectors::RocketDetector,           },
        { key: "魔方陣判定",       custom_trigger_key: :ct_every,    klass: CustomDetectors::MagicSquareDetector,      },
        { key: "角切り判定",       custom_trigger_key: :ct_capture,  klass: CustomDetectors::HikakukiriDetector,       },
        { key: "序盤飛角交換判定", custom_trigger_key: :ct_capture,  klass: CustomDetectors::HikakukoukanDetector,     },
        { key: "角交換判定",       custom_trigger_key: :ct_capture,  klass: CustomDetectors::KakukoukanDetector,       },
        { key: "玉頭戦判定",       custom_trigger_key: :ct_capture,  klass: CustomDetectors::GyokutousenDetector,      },
        { key: "開戦時の何か",     custom_trigger_key: :ct_outbreak, klass: CustomDetectors::OutbreakDetector,         },
      ]

      class << self
        def custom_trigger_keys_hash
          @custom_trigger_keys_hash ||= group_by(&:custom_trigger_key)
        end
      end
    end
  end
end
