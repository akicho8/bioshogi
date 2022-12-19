module Bioshogi
  module Board
    class Basic
      delegate :hash, to: :surface

      def initialize(&block)
        if block_given?
          yield self
        end
      end

      def surface
        @surface ||= {}
      end

      include UpdateMethods
      include ReaderMethods
      include TechniqueMatcherMethods

      prepend Explain::BoardPillerMethods
      prepend PieceCountsMethods
    end
  end
end
