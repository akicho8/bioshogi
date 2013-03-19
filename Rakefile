require "rspec/core/rake_task"
RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

require "bundler"
Bundler::GemHelper.install_tasks

# require "rake/clean"
# CLEAN << "pkg" << ".yardoc" << "doc" << "log" << "tmp"

require "yard"
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', 'spec/**/*_spec.rb']
  # t.options = ['--debug'] # optional arguments
end

task :normalize do
  puts `safefile -r --no-rsrip --no-delete-blank-lines  --no-hankaku --no-hankaku-space resources`
end
