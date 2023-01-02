require "bundler/gem_tasks"

################################################################################ rspec

require "rspec/core/rake_task"

desc "すべてのテスト"
RSpec::Core::RakeTask.new(:spec) do |t|
end
task :default => :spec

desc "動画変換のテスト"
RSpec::Core::RakeTask.new("spec:animation") do |t|
  # t.pattern = "spec/**/{animation,image}*_spec.rb"
  t.rspec_opts = "-f d --fail-fast -t animation"
end

desc "画像変換のテスト"
RSpec::Core::RakeTask.new("spec:screen_image") do |t|
  # t.pattern = "spec/**/{screen_image,image}*_spec.rb"
  t.rspec_opts = "-f d --fail-fast -t screen_image"
end

desc "戦法判定"
RSpec::Core::RakeTask.new("spec:tactic") do |t|
  t.rspec_opts = "-f d --fail-fast -t tactic"
end

desc "重要なところだけのテスト"
RSpec::Core::RakeTask.new("spec:core") do |t|
  # t.exclude_pattern = "spec/**/{animation,image}*_spec.rb"
  # t.rspec_opts = "-f d -t ~animation --fail-fast"
  t.rspec_opts = "-f d  -t ~screen_image -t ~animation -t ~tactic -t ~transform"
end
task :t => "spec:core"

desc "棋譜変換のテスト(TRANSFORM_OUTPUT=1 で expected を生成)"
RSpec::Core::RakeTask.new("spec:transform") do |t|
  t.rspec_opts = "-f d -t transform"
end

desc "ファイル名とモジュール名の対応付けが正しいことを検証する"
task "test:loader" do
  require "bioshogi"
  Zeitwerk::Loader.eager_load_all
  puts "OK"
end

################################################################################

desc "experiment以下のダンダースコアで始まるファイルを全削除"
task :clean do
  system %(fd -u -g '_*' experiment -x rm -f)
end

desc "戦法テスト"
task :validate do
  Dir.chdir("#{__dir__}/experiment") do
    system "ruby 戦法テスト.rb"
  end
end

desc "戦法ファイルの正規化"
task :normalize do
  require "bioshogi"
  Bioshogi::Explain::FileNormalizer.new.call
end
task :n => :normalize

desc "各戦法のレア度や戦法が確定する手数のテーブルの生成"
task :generate do
  require "bioshogi"
  Bioshogi::Explain::DistributionRatioGenerator.new.generate
  Bioshogi::Explain::TacticHitTurnTableGenerator.new.generate
end
task :g => :generate

desc "2chkifu読み込み変換テスト"
task "test:kifu" do
  Dir.chdir("#{__dir__}/experiment/2chkifu読み込み変換テスト") do
    system "ruby ./run.rb"
  end
end

desc "デモ生成"
task "demo" do
  Dir.chdir("#{__dir__}/experiment/animation_builder") do
    system "ruby 0100_demo.rb"
  end
  Dir.chdir("#{__dir__}/experiment/screen_image_renderer") do
    system "ruby 0100_demo.rb"
  end
end

namespace :color_theme_preview do
  desc "配色テーマのキャッシュ生成"
  task "generate" do
    require "bioshogi"
    Bioshogi::ScreenImage::ColorThemeInfo.each do |e|
      e.color_theme_cache_build(verbose: true)
    end
  end
end
