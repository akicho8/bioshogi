desc "戦法判定処理量確認 (最適化の効果が大きい戦法ランキング)"
task :bm do
  require "bioshogi"
  Bioshogi::Analysis::PerformanceBenchmark.new.call
end
