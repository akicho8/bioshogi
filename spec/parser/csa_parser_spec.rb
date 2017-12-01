require_relative "../spec_helper"

module Bushido
  describe Parser::CsaParser do
    it "棋譜部分のパース" do
      Parser::CsaParser.parse("1234FU").move_infos.first[:input].should == "1234FU"
      Parser::CsaParser.parse("+1234FU").move_infos.first[:input].should == "+1234FU"
      Parser::CsaParser.parse("+1234FU,T1").move_infos.first.should == {input: "+1234FU", used_seconds: 1}
    end
  end
end
