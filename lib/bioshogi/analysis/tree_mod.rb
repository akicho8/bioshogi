# frozen-string-literal: true

module Bioshogi
  module Analysis
    concern :TreeMod do
      included do
        include TreeSupport::Treeable
        include TreeSupport::Stringify
      end

      def parent
        unless defined?(@parent)
          if defined?(super) && v = super
            @parent = self.class.fetch(v)
          else
            @parent = nil
          end
        end

        @parent
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
    end
  end
end
