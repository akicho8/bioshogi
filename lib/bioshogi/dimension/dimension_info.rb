# frozen-string-literal: true

module Bioshogi
  module Dimension
    class DimensionInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :d5x5, name: "5x5", wh: [5, 5], },
        { key: :d9x9, name: "9x9", wh: [9, 9], },
      ]

      class << self
        def lookup(v)
          super || invert_table[v]
        end

        private

        def invert_table
          @invert_table ||= inject({}) { |a, e| a.merge(e.wh => e) }
        end
      end
    end
  end
end
