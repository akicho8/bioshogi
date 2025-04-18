# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :BasicAccessor do
      included do
        include TreeSupport::Treeable
        include TreeSupport::Stringify

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

      # 必ず alternate_name に反応するようにしておく
      def alternate_name
        if defined?(super)
          super
        end
      end

      # key と name は異なる
      def name
        alternate_name || super
      end

      def parent
        if super
          @parent ||= self.class.fetch(super)
        end
      end

      def children
        @children ||= self.class.find_all { |e| e.parent == self }
      end

      def cached_descendants
        @cached_descendants ||= descendants
      end

      def related_ancestors
        @related_ancestors ||= Array(super).collect { |e| self.class.fetch(e) }
      end

      def alias_names
        Array(super)
      end

      def sect_info
        SectInfo.fetch(sect_key)
      end

      def hold_piece_eq
        if v = super
          @hold_piece_eq ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def op_hold_piece_eq
        if defined?(super) && v = super
          @op_hold_piece_eq ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def hold_piece_in
        if v = super
          @hold_piece_in ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def hold_piece_not_in
        if v = super
          @hold_piece_not_in ||= PieceBox.new(Piece.s_to_h(v))
        end
      end

      def tactic_info
        TacticInfo.fetch(tactic_key)
      end

      def group_info
        return @group_info if instance_variable_defined?(:@group_info)
        if respond_to?(:group_key) && group_key
          @group_info ||= GroupInfo.fetch(group_key)
        end
      end

      def add_to_opponent
        return @add_to_opponent if instance_variable_defined?(:@add_to_opponent)
        if defined?(super) && v = super
          @add_to_opponent ||= TacticInfo.flat_lookup(v)
        end
      end

      def add_to_self
        return @add_to_self if instance_variable_defined?(:@add_to_self)
        if defined?(super) && v = super
          @add_to_self ||= TacticInfo.flat_lookup(v)
        end
      end

      def technique_verify_info
        @technique_verify_info ||= TechniqueVerifyInfo.lookup(key)
      end

      def skip_elements
        return @skip_elements if instance_variable_defined?(:@skip_elements)

        @skip_elements = nil
        if respond_to?(:skip_if_exist_keys)
          @skip_elements = Array(skip_if_exist_keys).collect { |e| TacticInfo.flat_lookup(e) }
        end
      end

      def hit_turn
        TacticHitTurnTable[key]
      end

      ################################################################################

      # この戦法を発動する代表とする棋譜ファイル
      def main_reference_file
        Pathname("#{__dir__}/#{tactic_info.name}/#{key}.kif")
      end

      # この戦法を発動する代表とする棋譜ファイルの情報
      def main_reference_info(options = {})
        Parser.file_parse(main_reference_file, options)
      end

      # この戦法を発動するファイルたち
      def reference_files
        [
          main_reference_file,
          *Pathname("#{__dir__}/#{tactic_info.name}").glob("#{key}/**/*.kif"),
        ]
      end

      ################################################################################
    end
  end
end
