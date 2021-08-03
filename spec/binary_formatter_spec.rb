require_relative "spec_helper"

module Bioshogi
  describe "バイナリ生成" do
    it "to_image" do
      info = Parser.parse("position startpos moves 7g7f 8c8d 2g2f")
      assert {  info.to_image(image_format: "png")[1..3] == "PNG"  }
      assert { info.to_image(image_format: "webp")[0..3] == "RIFF" }
    end

    it "to_animation" do
      info = Parser.parse("position startpos moves 7g7f 8c8d 2g2f")
      assert { info.to_animation(animation_format: "gif")[0..2] == "GIF" }
      assert { info.to_animation(animation_format: "webp")[0..3] == "RIFF"  }
    end

    # write("foo.apng") はできるが format = "apng" して to_blob はなぜかエラーになる
    it "APNGは対応していない……のか？" do
      info = Parser.parse("position startpos moves 7g7f 8c8d 2g2f")
      assert_raises(Magick::ImageMagickError) do
        info.to_animation(animation_format: "apng")
      end
    end
  end
end
