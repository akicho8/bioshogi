# 戦法チェックで最適化の効果が大きい戦法ランキング

module Bioshogi
  module Analysis
    class PerformanceBenchmark
      def call
        require "active_support/core_ext/benchmark"

        # Bioshogi.config[:analysis_feature] = false

        files = Bioshogi::ROOT.join("../../2chkifu").glob("**/*.ki2").sort
        files = Array(files).take((ARGV.first || 100).to_i)
        seconds = Benchmark.realtime do
          files.each do |file|
            info = Parser.file_parse(file, typical_error_case: :skip, analysis_feature: true)
            info.to_kif
          end
        end

        p seconds
        tp Bioshogi.analysis_run_counts.sort_by { |k, v| -v }.to_h
      end
    end
  end
end
