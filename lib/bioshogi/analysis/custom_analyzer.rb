# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CustomAnalyzer
      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        CustomDetectorInfo.each do |e|
          e.klass.new(executor).call
        end
      end
    end
  end
end
