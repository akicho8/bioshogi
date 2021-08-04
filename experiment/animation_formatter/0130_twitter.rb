require "../example_helper"

@info = Parser.parse("position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g")
# puts @info.animation_formatter.write("~/Desktop/direct_out.psd")
# puts @info.animation_formatter.write("~/Desktop/direct_out.pdf")
# puts @info.animation_formatter.write("~/Desktop/direct_out.mpg")
# puts @info.animation_formatter.write("~/Desktop/direct_out.mp4")
# puts @info.animation_formatter.write("~/Desktop/direct_out.mov")

@info.animation_formatter.main_canvas.write("direct_out.png")

def test(animation_format)
  bin = @info.animation_formatter(animation_format: animation_format).to_write_binary
  file = Pathname("blob_out.#{animation_format}")
  file.binwrite(bin)
  puts file
end

test("apng")                      # => nil

# test("mp4")                     # =>
# test("mov")                     # =>
# >> blob_out.apng
