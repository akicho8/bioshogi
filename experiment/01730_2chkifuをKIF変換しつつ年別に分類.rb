require "./setup"

files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}").sort
list = []

# files = "~/src/2chkifu/20000/26724.KI2"
# files = "~/src/2chkifu/10000/15647.KI2"

Array(files).each do |file|
  file = Pathname(file).expand_path
  info = Parser.file_parse(file, typical_error_case: :skip)
  if info.pi.header.entry_all_names.values.flatten.count >= 3
    list << file.to_s
  end
end

file = Pathname("2ch棋譜のペア対局一覧.txt")
file.write(list.join("\n"))
