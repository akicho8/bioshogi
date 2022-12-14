# frozen-string-literal: true

module Bioshogi
  module Formatter
    class SkillChecker
      attr_accessor :xcontainer
      attr_accessor :xparser

      def initialize(xcontainer)
        @xcontainer = xcontainer
        @xparser = xparser
      end

    end
  end
end
