require "../example_helper"

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_zip(basename_format: "xxx_%d")
Pathname("_output.zip").write(bin) # => 76981
puts `unzip -l _output.zip`
`open _output.zip`
# `open -a 'Google Chrome' _output.zip`
# >> Archive:  _output.zip
# >>   Length      Date    Time    Name
# >> ---------  ---------- -----   ----
# >>     29150  08-23-2021 19:46   xxx_0.png
# >>     30412  08-23-2021 19:46   xxx_1.png
# >>     31763  08-23-2021 19:46   xxx_2.png
# >> ---------                     -------
# >>     91325                     3 files
