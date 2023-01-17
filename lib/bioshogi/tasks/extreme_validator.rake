desc "2ch棋譜読み込み変換テスト(LIMIT=xxx)"
task "extreme_validator" do
  require "bioshogi"
  Bioshogi::ExtremeValidator.new(limit: ENV["LIMIT"]).call
end

desc "alias to extreme_validator"
task :"2" => :extreme_validator
