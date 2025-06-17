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
        motion_perform
      end

      # MotionDetector 系
      def motion_perform
        if executor.container.params[:analysis_motion_feature]
          # 主に手筋用で戦法チェックにも使える
          key = [soldier.piece.key, soldier.promoted, !!drop_hand] # :MOTION_TRIGGER_TABLE:
          if e = MotionTriggerTable[key]
            e.each do |e|
              Bioshogi.analysis_run_counts[e.key] += 1
              retv = perform_block do
                cold_war_verification(e)
                instance_exec(&e.motion_detector.func)
              end
              if retv
                skill_add(e)
              end
            end
          end
        end
      end
    end
  end
end
