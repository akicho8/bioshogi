desc "experiment以下のダンダースコアで始まるファイルを全削除"
task :clean do
  system %(fd -u -g '_*' experiment -x rm -f)
end
