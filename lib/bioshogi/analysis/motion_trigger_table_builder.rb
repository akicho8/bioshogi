module Bioshogi
  module Analysis
    class MotionTriggerTableBuilder
      def build
        hv = {}

        TagIndex.motion_type_values.each do |e|
          TriggerExpander.expand(e.motion_detector.trigger).each do |key|
            hv[key] ||= []
            hv[key] << e
          end
        end

        hv
      end

      def build2
        hv = {}

        CustomDetector2Info.each do |e|
          TriggerExpander.expand(e.trigger).each do |key|
            hv[key] ||= []
            hv[key] << e
          end
        end

        hv
      end
    end
  end
end
