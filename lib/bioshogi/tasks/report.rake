task :r => :report

desc "レポート"
task :report do
  require "bioshogi"
  Bioshogi::Analysis::TagReporter.new.call
end
