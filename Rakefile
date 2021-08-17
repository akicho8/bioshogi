require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :clean do
  system %(find #{__dir__} -name "_*" -exec echo {} \\;)
  puts "本当に実行するには rake clean_run としてください"
end

task :clean_run do
  system %(find #{__dir__} -name "_*" -exec rm -f {} \\;)
end
