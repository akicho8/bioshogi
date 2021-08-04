require "../example_helper"

info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g")
puts info.animation_formatter.write("~/Desktop/out.psd")
puts info.animation_formatter.write("~/Desktop/out.pdf")
puts info.animation_formatter.write("~/Desktop/out.mpg")
puts info.animation_formatter.write("~/Desktop/out.mp4")
puts info.animation_formatter.write("~/Desktop/out.mov")
# >> out.psd
# >> out.pdf
# >> out.mpg
