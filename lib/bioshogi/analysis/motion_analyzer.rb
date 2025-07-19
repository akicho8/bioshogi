# frozen-string-literal: true

module Bioshogi
  module Analysis
    class MotionAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        key = [soldier.piece.key, soldier.promoted, !!drop_hand]
        if e = MotionTriggerTable[key]
          e.each do |e|
            Bioshogi.analysis_run_counts[e.key] += 1
            retval = perform_block do
              instance_exec(&e.motion_detector.func)
            end
            if retval
              tag_add(e)
            end
          end
        end
      end
    end
  end
end
