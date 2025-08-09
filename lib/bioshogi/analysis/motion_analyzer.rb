# frozen-string-literal: true

module Bioshogi
  module Analysis
    class MotionAnalyzer
      include ExecuterDsl

      class << self
        def trigger_table
          @trigger_table ||= TagIndex.motion_type_values.each_with_object({}) do |e, m|
            e.motion_detector.triggers.each do |key|
              m[key] ||= []
              m[key] << e
            end
          end
        end
      end

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        key = [soldier.piece.key, soldier.promoted, !!drop_hand]
        if e = self.class.trigger_table[key]
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
