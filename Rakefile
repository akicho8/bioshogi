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
  # t.rspec_opts = "-f d -t ~animation --fail-fast"
  t.rspec_opts = "-f d -t ~animation"
end

################################################################################

desc "ダンダースコアで始まるファイルを全削除"
task :clean do
  system %(find #{__dir__} -name "_*" -exec rm -f {} \\;)
end

desc "戦法テスト"
task :validate do
  Dir.chdir("#{__dir__}/experiment") do
    system "ruby 戦法テスト.rb"
    system "ruby 各戦法が確定する手数のテーブルを生成.rb"
    system "ruby 戦法正規化.rb"
  end
end

desc "2chkifu読み込み変換テスト"
task "test:kifu" do
  Dir.chdir("#{__dir__}/experiment") do
    system "ruby 2chkifu読み込み変換テスト.rb"
  end
end

desc "デモ生成"
task "demo" do
  Dir.chdir("#{__dir__}/experiment/animation_builder") do
    system "ruby 0100_demo.rb"
  end
  Dir.chdir("#{__dir__}/experiment/image_renderer") do
    system "ruby 0100_demo.rb"
  end
end

namespace :color_theme_preview do
  desc "配色テーマのキャッシュ生成"
  task "generate" do
    require "bioshogi"
    Bioshogi::ImageRenderer::ColorThemeInfo.each do |e|
      e.color_theme_cache_build(verbose: true)
    end
  end
end

