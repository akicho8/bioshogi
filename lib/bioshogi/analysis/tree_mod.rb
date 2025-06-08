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
        unless defined?(@related_ancestors)
          if defined?(super) && v = super
            @related_ancestors = Array(v).collect { |e| self.class.fetch(e) }
          else
            @related_ancestors = []
          end
        end

        @related_ancestors
      end
    end
  end
end
