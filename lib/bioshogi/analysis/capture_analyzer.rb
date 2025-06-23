# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CaptureAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        TagIndex.capture_type_values.each do |e|
          Bioshogi.analysis_run_counts[e.key] += 1
          retv = perform_block do
            instance_exec(&e.if_capture_then)
          end
          if retv
            tag_add(e)
          end
        end
      end
    end
  end
end
