require "../example_helper"

info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f")
bin = info.to_animation_gif(video_speed: 0.5)
Pathname("_output.gif").write(bin) # => 33233
`open -a 'Google Chrome' _output.gif`
