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

      def sect_info
        @sect_info ||= SectInfo.fetch(sect_key)
      end

      def hold_piece_eq
        unless defined?(@hold_piece_eq)
          if v = super
            @hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_eq = nil
          end
        end

        @hold_piece_eq
      end

      def op_hold_piece_eq
        unless defined?(@op_hold_piece_eq)
          if v = super
            @op_hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @op_hold_piece_eq = nil
          end
        end

        @op_hold_piece_eq
      end

      def hold_piece_in
        unless defined?(@hold_piece_in)
          if v = super
            @hold_piece_in = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_in = nil
          end
        end

        @hold_piece_in
      end

      def hold_piece_not_in
        unless defined?(@hold_piece_not_in)
          if v = super
            @hold_piece_not_in = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_not_in = nil
          end
        end

        @hold_piece_not_in
      end

      def tactic_info
        @tactic_info ||= TacticInfo.fetch(tactic_key)
      end

      def category
        unless defined?(@category)
          @category = TagIndex.fetch_if(super)
        end

        @category
      end

      def group_info
        unless defined?(@group_info)
          @group_info = GroupInfo.fetch_if(group_key)
        end

        @group_info
      end

      def motion_detector
        unless defined?(@motion_detector)
          @motion_detector = MotionDetector.lookup(key)
        end

        @motion_detector
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

      def motion_detector
        unless defined?(@motion_detector)
          @motion_detector = MotionDetector.lookup(key)
        end

        @motion_detector
      end

      def skip_if_exist
        unless defined?(@skip_if_exist)
          @skip_if_exist = Array(super).collect { |e| TagIndex.fetch(e) }
        end

        @skip_if_exist
      end

      def hit_turn
        @hit_turn ||= TacticHitTurnTable[key]
      end
    end
  end
end
