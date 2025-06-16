module Bioshogi
  module Analysis
    class MotionTriggerTableBuilder
      def build
        TagIndex.motion_type_values.each_with_object({}) do |e, m|
          Array.wrap(e.motion_detector.trigger).each do |trigger|
            trigger_expand(trigger).each do |key|
              m[key] ||= []
              m[key] << e
            end
          end
        end
      end

      private

      def trigger_expand(trigger)
        promoted = promoted_expand(trigger[:promoted])
        motion = motion_expand(trigger[:motion])

        av = []
        Array.wrap(trigger[:piece_key]).each do |x|
          Array.wrap(promoted).each do |y|
            Array.wrap(motion).each do |z|
              av << [x, y, z]
            end
          end
        end
        av
      end

      def promoted_expand(promoted)
        case promoted
        when true
          true
        when false
          false
        when :both
          [
            true,
            false,
          ]
        else
          raise "must not happen"
        end
      end

      def motion_expand(motion)
        case motion
        when :move
          false
        when :drop
          true
        when :both
          [
            true,               # 打
            false,              # 移動
          ]
        else
          raise "must not happen"
        end
      end
    end
  end
end
