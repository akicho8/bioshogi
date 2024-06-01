require "../setup"
# Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_zip
Pathname("_output.zip").write(bin) # => 86150
puts `unzip -l _output.zip`
`open _output.zip`
# `open -a 'Google Chrome' _output.zip`
# >> Archive:  _output.zip
# >>   Length      Date    Time    Name
# >> ---------  ---------- -----   ----
# >>     33095  10-04-2021 14:27   0000.png
# >>     34516  10-04-2021 14:27   0001.png
# >>     35725  10-04-2021 14:27   0002.png
# >> ---------                     -------
# >>    103336                     3 files
