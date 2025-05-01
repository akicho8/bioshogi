desc "戦法判定確認"
task :tactic_detect do
  require "bioshogi"
  Bioshogi::Analysis::TacticDetect.new.call
end

desc "alias to tactic_detect"
task :v => :tactic_detect
