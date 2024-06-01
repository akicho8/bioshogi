desc "デモ生成"
task :demo do
  require "bioshogi"
  Bioshogi::Formatter::Animation::DemoBuilder.new.call
  # Dir.chdir("#{__dir__}/workbench/animation_builder") do
  #   system "ruby 0100_demo.rb"
  # end
  # Dir.chdir("#{__dir__}/workbench/screen_image_renderer") do
  #   system "ruby 0100_demo.rb"
  # end
end
