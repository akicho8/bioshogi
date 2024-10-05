desc "alias to generate"
task :g => :generate

desc "各戦法のレア度や戦法が確定する手数のテーブルの生成"
task :generate do
  require "bioshogi"
  # Bioshogi::Explain::DistributionRatioGenerator.new.generate
  Bioshogi::Explain::TacticHitTurnTableGenerator.new.call
end
