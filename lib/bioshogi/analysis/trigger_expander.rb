module Bioshogi
  module Analysis
    module TriggerExpander
      extend self

      def expand(trigger)
        Array.wrap(trigger).flat_map do |trigger|
          trigger_expand(trigger)
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
