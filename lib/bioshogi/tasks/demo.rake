desc "デモ生成"
task :demo do
  Dir.chdir("#{__dir__}/experiment/animation_builder") do
    system "ruby 0100_demo.rb"
  end
  Dir.chdir("#{__dir__}/experiment/screen_image_renderer") do
    system "ruby 0100_demo.rb"
  end
end
