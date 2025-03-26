require "spec_helper"

RSpec.describe Bioshogi do
  describe "棋譜ファイルの読み込み" do
    it "できる" do
      Bioshogi::Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.kif"))
      Bioshogi::Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.ki2"))
    end
    it "できない" do
      assert_raises { Bioshogi::Parser.file_parse(Pathname(__FILE__).dirname.join("unknown.bin")) }
    end
  end
end
