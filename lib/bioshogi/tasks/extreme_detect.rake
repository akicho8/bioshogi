desc "2ch棋譜読み込み変換テスト(LIMIT=xxx)"
task "extreme_detect" do
  require "bioshogi"
  Bioshogi::ExtremeDetect.new(limit: ENV["LIMIT"]).call
end

desc "alias to extreme_detect"
task :"2" => :extreme_detect
