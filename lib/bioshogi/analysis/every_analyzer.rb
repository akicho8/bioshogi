# frozen-string-literal: true

module Bioshogi
  module Analysis
    class EveryAnalyzer
      include ExecuterDsl

      attr_reader :executor

      def initialize(executor)
        @executor = executor
      end

      def call
        TagIndex.every_type_values.each do |e|
          Bioshogi.analysis_run_counts[e.key] += 1
          if instance_exec(&e.if_true_then)
            tag_add(e)
          end
        end
      end
    end
  end
end
