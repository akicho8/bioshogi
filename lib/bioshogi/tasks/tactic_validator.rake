desc "戦法判定確認"
task :tactic_validate do
  require "bioshogi"
  Bioshogi::Analysis::TacticValidator.new.call
end

desc "alias to tactic_validate"
task :v => :tactic_validate
