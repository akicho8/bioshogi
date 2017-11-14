require_relative "spec_helper"

module Bushido
  describe Bushido do
    describe "棋譜ファイルの読み込み" do
      it "できる" do
        Parser.parse_file(Pathname(__FILE__).dirname.join("files/sample1.kif"))
        Parser.parse_file(Pathname(__FILE__).dirname.join("files/sample1.ki2"))
      end
      it "できない" do
        expect { Parser.parse_file(Pathname(__FILE__).dirname.join("sample1.bin")) }.to raise_error(Errno::ENOENT)
      end
    end

    describe "棋譜コンテンツのパース" do
      it "できる" do
        Parser.parse("手数----指手---------消費時間--").class.should == Parser::KifParser
        Parser.parse("").class.should == Parser::Ki2Parser
        Parser.parse(nil).class.should == Parser::Ki2Parser
      end

      # it "できない" do
      #   expect { Bushido::Parser.parse(nil) }.to raise_error(Bushido::FileFormatError)
      #   expect { Bushido::Parser.parse("")  }.to raise_error(Bushido::FileFormatError)
      # end
    end
  end
end
