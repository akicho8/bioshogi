require "../example_helper"

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_png(one_frame_duration: 0.5)
Pathname("_output.apng").write(bin) # => 38007
`open -a 'Google Chrome' _output.apng`
