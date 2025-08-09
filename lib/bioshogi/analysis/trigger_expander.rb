module Bioshogi
  module Analysis
    module TriggerExpander
      extend self

      def expand(trigger)
        Array.wrap(trigger).flat_map do |trigger|
          expand_one(trigger)
        end
      end

      private

      def expand_one(trigger)
        piece_key = piece_key_by(trigger[:piece_key])
        promoted = promoted_by(trigger[:promoted])
        motion = motion_by(trigger[:motion])

        piece_key.flat_map do |x|
          promoted.flat_map do |y|
            motion.collect do |z|
              [x, y, z]
            end
          end
        end
      end

      # ここで piece_key == :all なら Piece.keys を返す案もある
      def piece_key_by(piece_key)
        Array.wrap(piece_key).collect do |e|
          Piece.fetch(e).key
        end
      end

      def promoted_by(promoted)
        case promoted
        when true
          [true]
        when false
          [false]
        when :both
          [true, false]
        else
          raise "must not happen"
        end
      end

      def motion_by(motion)
        case motion
        when :move
          [false]
        when :drop
          [true]
        when :both
          [true, false]
        else
          raise "must not happen"
        end
      end
    end
  end
end
