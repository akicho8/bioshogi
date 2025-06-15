module Bioshogi
  module Analysis
    class TacticInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :attack,    },
        { key: :defense,   },
        { key: :technique, },
        { key: :note,      },
      ]

      def model
        @model ||= "bioshogi/analysis/#{key}_info".classify.constantize
      end

      def name
        model.human_name
      end

      def list_key
        "#{key}_infos"
      end
    end
  end
end
