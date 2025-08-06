# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CustomAnalyzer
      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call(custom_trigger_key)
        if e = CustomTriggerInfo.fetch(custom_trigger_key).custom_detector_infos
          e.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            e.klass.new(executor).call
          end
        end
      end
    end
  end
end
