# frozen-string-literal: true

module Bioshogi
  module Analysis
    class ShapeAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        if e = TagIndex.shape_trigger_table[black_side_soldier]
          e.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            if perform_block { various_conditions(e) }
              tag_add(e)
            end
          end
        end
      end
    end
  end
end
