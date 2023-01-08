desc "ファイル名と配置の関係が正しいのを確認する"
task :loader do
  require "bioshogi"
  Zeitwerk::Loader.eager_load_all
  puts "OK"
end

task :l => :loader
