require "../example_helper"

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_gif(video_speed: 0.5)
Pathname("_output.apng").write(bin) # => 33719
`open -a 'Google Chrome' _output.apng`
