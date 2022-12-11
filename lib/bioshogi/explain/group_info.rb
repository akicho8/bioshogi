# frozen-string-literal: true

module Bioshogi
  module Explain
    class GroupInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "右玉", },
      ]

      def values
        @values ||= TacticInfo.all_elements.find_all { |e| e.group_info === self }
      end
    end
  end
end
