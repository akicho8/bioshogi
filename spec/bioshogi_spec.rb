require "spec_helper"

module Bioshogi
  describe Bioshogi do
    describe "棋譜ファイルの読み込み" do
      it "できる" do
        Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.kif"))
        Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.ki2"))
      end
      it "できない" do
        assert_raises { Parser.file_parse(Pathname(__FILE__).dirname.join("unknown.bin")) }
      end
    end
  end
end
