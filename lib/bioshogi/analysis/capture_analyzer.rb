# frozen-string-literal: true

module Bioshogi
  module Analysis
    class CaptureAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        TagIndex.capture_type_values.each do |e|
          if instance_exec(&e.if_capture_then)
            tag_add(e)
          end
        end
      end
    end
  end
end
