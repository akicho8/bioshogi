require "#{__dir__}/setup"
outout_dir = Pathname("~/src/2ch棋譜変換後").expand_path
files = Pathname.glob("../../2chkifu/**/*.{ki2,KI2}")
files = files.take(5000)
files = files.collect(&:expand_path)
files.each do |file|
  info = Parser.file_parse(file, typical_error_case: :skip)
  outfile = outout_dir.join(file.basename)
  outfile.write(info.to_kif)
  print "."
  STDOUT.flush
end
puts
# >> .
