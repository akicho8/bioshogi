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
        key = [soldier.piece.key, soldier.promoted, !!drop_hand]
        if av = XmotionDetectorInfo.trigger_table[key]
          av.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            e.klass.new(executor).call
          end
        end
      end
    end
  end
end
