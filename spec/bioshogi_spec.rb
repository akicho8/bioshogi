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

    describe "棋譜コンテンツのパース" do
      it "できる" do
        assert { Parser.parse("手数----指手---------消費時間--").class == Parser::KifParser }
        assert { Parser.parse("").class == Parser::Ki2Parser }
        assert { Parser.parse(nil).class == Parser::Ki2Parser }
      end

      # it "できない" do
      #   expect { Bioshogi::Parser.parse(nil) }.to raise_error(Bioshogi::FileFormatError)
      #   expect { Bioshogi::Parser.parse("")  }.to raise_error(Bioshogi::FileFormatError)
      # end
    end
  end
end
