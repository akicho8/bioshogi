require_relative "spec_helper"

module Warabi
  describe Warabi do
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
        Parser.parse("手数----指手---------消費時間--").class.should == Parser::KifParser
        Parser.parse("").class.should == Parser::Ki2Parser
        Parser.parse(nil).class.should == Parser::Ki2Parser
      end

      # it "できない" do
      #   expect { Warabi::Parser.parse(nil) }.to raise_error(Warabi::FileFormatError)
      #   expect { Warabi::Parser.parse("")  }.to raise_error(Warabi::FileFormatError)
      # end
    end
  end
end
