desc "alias to tactic_stat"
task :t => :tactic_stat

desc "戦法A→B→C問題抽出"
task :tactic_stat do
  require "bioshogi"
  Bioshogi::Explain::TacticStat.new.call
end
