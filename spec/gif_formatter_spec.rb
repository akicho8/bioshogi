require_relative "spec_helper"

module Bioshogi
  describe "GIF生成" do
    it do
      info = Parser.parse("position startpos moves 7g7f 8c8d 2g2f")
      bin = info.to_gif
      assert { bin[0...3] === "GIF" }
    end
  end
end
