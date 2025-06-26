# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :BasicAccessor do
      included do
        delegate :tactic_key, to: "self.class"
      end

      class_methods do
        # ["ポンポン桂"].name # => "ポンポン桂"
        # ["富沢キック"].name # => "ポンポン桂"
        def lookup(v)
          super || other_table[v]
        end

        def tactic_key
          @tactic_key ||= name.demodulize.underscore.remove(/_info/).to_sym
        end

        private

        def other_table
          @other_table ||= inject({}) do |a, e|
            e.alias_names.inject(a) do |a, v|
              a.merge(v => e)
            end
          end
        end
      end

      def alias_names
        @alias_names ||= Array(super)
      end

      def tactic_info
        @tactic_info ||= TacticInfo.fetch(tactic_key)
      end

      def group_info
        unless defined?(@group_info)
          @group_info = GroupInfo.fetch_if(group_key)
        end

        @group_info
      end

      def add_to_opponent
        unless defined?(@add_to_opponent)
          @add_to_opponent = TagIndex.fetch_if(super)
        end

        @add_to_opponent
      end

      def add_to_self
        unless defined?(@add_to_self)
          @add_to_self = TagIndex.fetch_if(super)
        end

        @add_to_self
      end

      def hit_turn
        @hit_turn ||= TacticHitTurnTable[key]
      end

      ################################################################################

      def shape_detector
        unless defined?(@shape_detector)
          @shape_detector = ShapeDetector.lookup(key)
        end

        @shape_detector
      end

      def motion_detector
        unless defined?(@motion_detector)
          @motion_detector = MotionDetector.lookup(key)
        end

        @motion_detector
      end

      def every_detector
        unless defined?(@every_detector)
          @every_detector = EveryDetector.lookup(key)
        end

        @every_detector
      end

      def capture_detector
        unless defined?(@capture_detector)
          @capture_detector = CaptureDetector.lookup(key)
        end

        @capture_detector
      end

      ################################################################################
    end
  end
end
