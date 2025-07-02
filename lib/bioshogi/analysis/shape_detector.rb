# frozen-string-literal: true

module Bioshogi
  module Analysis
    class ShapeDetector
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "居飛車",
          func: -> {
            skip_if { player.tag_bundle.include?("振り飛車") }
          },
        },
        {
          key: "振り飛車",
          func: -> {
            skip_if { player.tag_bundle.include?("居飛車") }
          },
        },
      ]
    end
  end
end
