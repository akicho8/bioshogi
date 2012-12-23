require "rspec/core/rake_task"
RSpec::Core::RakeTask.new
task :default => :spec

task :normalize do
  puts `safefile -r --no-rsrip --no-delete-blank-lines  --no-hankaku --no-hankaku-space resources`
end
