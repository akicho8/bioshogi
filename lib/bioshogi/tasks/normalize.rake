desc "alias to normalize"
task :n => :normalize

desc "戦法ファイルの正規化"
task :normalize do
  require "bioshogi"
  Bioshogi::Explain::FileNormalizer.new.call
end
