require "bundler/gem_tasks"

################################################################################ rspec

require "rspec/core/rake_task"

desc "すべてのテスト"
RSpec::Core::RakeTask.new(:spec) do |t|
end
task :default => :spec

desc "動画/画像変換のテスト"
RSpec::Core::RakeTask.new("spec:animation") do |t|
  # t.pattern = "spec/**/{animation,image}*_spec.rb"
  t.rspec_opts = "-f d --fail-fast -t animation"
end

desc "重要なところだけのテスト"
RSpec::Core::RakeTask.new("spec:core") do |t|
  # t.exclude_pattern = "spec/**/{animation,image}*_spec.rb"
  t.rspec_opts = "-f d --fail-fast -t ~animation"
end

################################################################################

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
