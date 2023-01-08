desc "2chkifu読み込み変換テスト"
task "all_kifu" do
  Dir.chdir("#{__dir__}/experiment/2chkifu読み込み変換テスト") do
    system "ruby ./run.rb"
  end
end
