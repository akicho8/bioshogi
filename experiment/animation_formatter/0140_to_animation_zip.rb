require "../example_helper"
Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_zip
Pathname("_output.zip").write(bin) # => 76975
puts `unzip -l _output.zip`
`open _output.zip`
# `open -a 'Google Chrome' _output.zip`
# >> move: 0 / 2
# >> Archive:  _output.zip
# >>   Length      Date    Time    Name
# >> ---------  ---------- -----   ----
# >>     29150  08-24-2021 06:45   0000.png
# >>     30412  08-24-2021 06:45   0001.png
# >>     31763  08-24-2021 06:45   0002.png
# >> ---------                     -------
# >>     91325                     3 files
