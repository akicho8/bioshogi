require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :clean do
  system %(find #{__dir__} -name "_*" -exec rm -f {} \\;)
end

task :validate do
  Dir.chdir("#{__dir__}/experiment") do
    system "ruby 戦法テスト.rb"
    system "ruby 各戦法が確定する手数のテーブルを生成.rb"
    system "ruby 戦法正規化.rb"
  end
end
