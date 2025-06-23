# frozen-string-literal: true

module Bioshogi
  module Analysis
    class EveryAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        TagIndex.every_type_values.each do |e|
          Bioshogi.analysis_run_counts[e.key] += 1
          retv = perform_block do
            instance_exec(&e.every_detector.func)
          end
          if retv
            tag_add(e)
          end
        end
      end
    end
  end
end
