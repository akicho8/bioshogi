desc "戦法判定確認"
task :tactic_validate do
  require "bioshogi"
  Bioshogi::Explain::TacticValidator.new.call
end

task :v => :tactic_validate
