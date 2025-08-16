module Bioshogi
  module Analysis
    class TacticInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :attack,    name: AttackInfo.human_name,    },
        { key: :defense,   name: DefenseInfo.human_name,   },
        { key: :technique, name: TechniqueInfo.human_name, },
        { key: :note,      name: NoteInfo.human_name,      },
      ]

      class << self
        def lookup(v)
          super || invert_table[v]
        end

        private

        def invert_table
          @invert_table ||= inject({}) { |a, e| a.merge(e.name => e) }
        end
      end

      def model
        @model ||= "bioshogi/analysis/#{key}_info".classify.constantize
      end

      def name
        model.human_name
      end

      def list_key
        :"#{key}_infos"
      end
    end
  end
end
