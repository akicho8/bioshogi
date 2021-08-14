require "spec_helper"
require "rmagick"

module Bioshogi
  describe AnimationFormatter do
    it "引数が正しくImageFormatterに渡っている" do
      info = Parser.parse("position startpos moves 7g7f")
      formatter = info.animation_formatter(animation_format: "gif", width: 320)
      bin = formatter.to_write_binary
      image = Magick::Image.from_blob(bin).first
      assert { image.columns == 320 }
    end

    it "to_blobするとAPNGは生成できない" do
      info = Parser.parse("position startpos moves 7g7f")
      formatter = info.animation_formatter(animation_format: "apng")
      assert_raises(Magick::ImageMagickError) do
        formatter.to_blob_binary
      end
    end

    it "to_write_binaryならapngを生成できる" do
      info = Parser.parse("position startpos moves 7g7f")
      formatter = info.animation_formatter(animation_format: "apng")
      assert { formatter.to_write_binary }
    end
  end
end
# >> ...
# >> 
# >> Finished in 6.39 seconds (files took 1.79 seconds to load)
# >> 3 examples, 0 failures
# >> 
