# 戦法チェックで最適化の効果が大きい戦法ランキング

module Bioshogi
  module Analysis
    class PerformanceBenchmark
      def call
        require "active_support/core_ext/benchmark"

        # Bioshogi.config[:analysis_feature] = false

        path = Bioshogi::ROOT.join("../../2chkifu").expand_path
        files = path.glob("**/*.ki2").sort
        max = 100
        files = Array(files).take(max)
        seconds = Benchmark.realtime do
          files.each do |file|
            print "."
            STDOUT.flush
            info = Parser.file_parse(file, typical_error_case: :skip, analysis_feature: true)
            info.to_kif
          end
        end
        puts
        p seconds
        tp Bioshogi.analysis_run_counts.sort_by { |k, v| -v }.take(30).to_h
      end
    end
  end
end
