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
          if defined?(super) && v = super
            @hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_eq = nil
          end
        end

        @hold_piece_eq
      end

      def op_hold_piece_eq
        unless defined?(@op_hold_piece_eq)
          if defined?(super) && v = super
            @op_hold_piece_eq = PieceBox.new(Piece.s_to_h(v))
          else
            @op_hold_piece_eq = nil
          end
        end

        @op_hold_piece_eq
      end

      def hold_piece_in
        unless defined?(@hold_piece_in)
          if defined?(super) && v = super
            @hold_piece_in = PieceBox.new(Piece.s_to_h(v))
          else
            @hold_piece_in = nil
          end
        end

        @hold_piece_in
      end

      def hold_piece_not_in
        unless defined?(@hold_piece_not_in)
          if defined?(super) && v = super
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
          if defined?(super) && v = super
            @category = TagIndex.fetch(v)
          else
            @category = nil
          end
        end

        @category
      end

      # def sub_category
      #   unless defined?(@sub_category)
      #     if defined?(super) && v = super
      #       @sub_category = TagIndex.fetch(v)
      #     else
      #       @sub_category = nil
      #     end
      #   end
      #
      #   @sub_category
      # end

      def group_info
        unless defined?(@group_info)
          @group_info = GroupInfo.fetch_if(group_key)
        end

        @group_info
      end

      def trigger_params
        unless defined?(@trigger_params)
          v = trigger_piece_key

          if v && TriggerInfo.lookup(key)
            raise ArgumentError, "trigger_piece_key があるのに TriggerInfo でも定義されている"
          end

          unless v
            v = TriggerInfo.lookup(key)&.trigger_piece_key
          end

          @trigger_params = v
        end

        @trigger_params
      end

      def delete_infos
        unless defined?(@delete_infos)
          if v = delete_keys
            @delete_infos = Array(v).collect { |e| TagIndex.fetch(e) }
          else
            @delete_infos = []
          end
        end

        @delete_infos
      end

      def add_to_opponent
        unless defined?(@add_to_opponent)
          if defined?(super) && v = super
            @add_to_opponent = TagIndex.fetch(v)
          else
            @add_to_opponent = nil
          end
        end

        @add_to_opponent
      end

      def add_to_self
        unless defined?(@add_to_self)
          if defined?(super) && v = super
            @add_to_self = TagIndex.fetch(v)
          else
            @add_to_self = nil
          end
        end

        @add_to_self
      end

      def tag_detector
        unless defined?(@tag_detector)
          @tag_detector = TagDetector.lookup(key)
        end

        @tag_detector
      end

      def skip_elements
        unless defined?(@skip_elements)
          if v = skip_if_exist_keys
            @skip_elements = Array(v).collect { |e| TagIndex.fetch(e) }
          else
            @skip_elements = nil
          end
        end

        @skip_elements
      end

      def only_preset_attr
        unless defined?(@only_preset_attr)
          if defined?(super) && v = super
            @only_preset_attr = v
          else
            @only_preset_attr = nil
          end
        end

        @only_preset_attr
      end

      def hit_turn
        @hit_turn ||= TacticHitTurnTable[key]
      end
    end
  end
end
