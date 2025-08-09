# frozen-string-literal: true

module Bioshogi
  module Analysis
    class XmotionAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        if av = XmotionDetectorInfo.trigger_table[motion_key]
          av.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            e.klass.new(executor).call
          end
        end
      end
    end
  end
end
