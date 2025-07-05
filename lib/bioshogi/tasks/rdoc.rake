require "rdoc/task"

RDoc::Task.new do |rdoc|
  # rdoc.main = "README.md"     # 最初に表示されるページ（任意）
  rdoc.rdoc_dir = "rdoc"       # 出力先ディレクトリ（デフォルト: doc）
  # rdoc.title = "My Project Documentation" # ドキュメントタイトル（任意）

  # ドキュメント対象ファイル（ここをプロジェクトに合わせて調整）
  # rdoc.rdoc_files.include("lib/**/*.rb", "README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end
