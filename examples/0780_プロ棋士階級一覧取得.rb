require "./example_helper"
# Bushido.config[:skill_set_flag] = false

tags = []
files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}").sort
files = files.take((ARGV.first || 1000_0000).to_i)

# files = "~/src/2chkifu/20000/26724.KI2"
# files = "~/src/2chkifu/10000/15647.KI2"

Array(files).each do |file|
  file = Pathname(file).expand_path
  info = Parser.file_parse(file, typical_error_case: :skip)
  print "."
  begin
    tags += info.header.to_names_h.values.flatten
  rescue => error
    puts file
    raise error
  end
end

file = Pathname("タグ一覧.txt")
file.write(tags.uniq.sort.join("\n"))
# >> .
