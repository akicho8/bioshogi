require "../example_helper"

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_gif(one_frame_duration: 0.5)
Pathname("_output.gif").write(bin) # => 33233
`open -a 'Google Chrome' _output.gif`
