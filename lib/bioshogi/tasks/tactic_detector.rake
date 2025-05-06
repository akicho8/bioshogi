desc "戦法判定確認"
task :tactic_detector do
  require "bioshogi"
  Bioshogi::Analysis::TacticDetector.new.call
end

desc "alias to tactic_detector"
task :v => :tactic_detector
