desc "戦法テスト"
task :validate do
  Dir.chdir("#{__dir__}/experiment") do
    system "ruby 戦法テスト.rb"
  end
end
