desc "2ch棋譜読み込み変換テスト(MAX=xxx)"
task "extreme_detect" => :prepare do
  Bioshogi::ExtremeDetect.new.call
end

desc "alias to extreme_detect"
task :"2" => :extreme_detect
