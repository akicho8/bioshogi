require "rspec/core/rake_task"

desc "すべてのテスト"
RSpec::Core::RakeTask.new(:test) do |t|
end
task :default => :test

task :c => "test:core"

namespace :test do
  desc "重要なところだけのテスト"
  RSpec::Core::RakeTask.new(:core) do |t|
    # t.exclude_pattern = "spec/**/{animation,image}*_spec.rb"
    # t.rspec_opts = "-f d -t ~animation --fail-fast"
    t.rspec_opts = "-f d  -t ~screen_image -t ~animation -t ~tactic -t ~transform"
  end

  desc "戦法判定"
  RSpec::Core::RakeTask.new(:tactic) do |t|
    t.rspec_opts = "-f d --fail-fast -t tactic"
  end

  desc "棋譜変換のテスト(TRANSFORM_OUTPUT=1 で expected を生成)"
  RSpec::Core::RakeTask.new(:transform) do |t|
    t.rspec_opts = "-f d -t transform"
  end

  desc "画像変換のテスト"
  RSpec::Core::RakeTask.new(:screen_image) do |t|
    # t.pattern = "spec/**/{screen_image,image}*_spec.rb"
    t.rspec_opts = "-f d --fail-fast -t screen_image"
  end

  desc "動画変換のテスト"
  RSpec::Core::RakeTask.new(:animation) do |t|
    # t.pattern = "spec/**/{animation,image}*_spec.rb"
    t.rspec_opts = "-f d --fail-fast -t animation"
  end
end
