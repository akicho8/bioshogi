require "../example_helper"

info = Parser.parse("position startpos moves 7g7f 8c8d")
bin = info.to_animation_png(one_frame_duration: 0.5)
Pathname("_output.apng").write(bin) # => 38007
puts `identify _output.apng`
`open -a 'Google Chrome' _output.apng`
# >> _output.apng PNG 1200x630 1200x630+0+0 16-bit Grayscale Gray 38007B 0.000u 0:00.000
