desc "alias to normalize"
task :n => :normalize

desc "戦法ファイルの正規化"
task :normalize do
  require "bioshogi"
  Bioshogi::Analysis::FileNormalizer.new.call
end
