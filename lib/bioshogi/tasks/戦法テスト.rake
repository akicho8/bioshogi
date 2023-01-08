desc "戦法テスト"
task :validate do
  require "bioshogi"
  Bioshogi::Explain::SenpoTest.new.call
end

task :v => :validate
