require_relative "spec_helper"

module Bioshogi
  describe Bioshogi do
    describe "棋譜ファイルの読み込み" do
      it "できる" do
        Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.kif"))
        Parser.file_parse(Pathname(__FILE__).dirname.join("files/sample1.ki2"))
      end
      it "できない" do
        expect { Parser.file_parse(Pathname(__FILE__).dirname.join("sample1.bin")) }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
