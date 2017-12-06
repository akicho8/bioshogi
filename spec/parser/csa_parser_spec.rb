require_relative "../spec_helper"

module Bushido
  describe Parser::CsaParser do
    it "棋譜部分のパース" do
      Parser::CsaParser.parse("1234FU").move_infos.first[:input].should == "1234FU"
      Parser::CsaParser.parse("+1234FU").move_infos.first[:input].should == "+1234FU"
      Parser::CsaParser.parse("+1234FU,T1").move_infos.first.should == {input: "+1234FU", used_seconds: 1}
    end

    it "残り時間の変換" do
      info = Parser.parse("V2.2\n$TIME_LIMIT: 00:00+05")
      assert info.to_kif.include?("0分 (1手5秒)")
      assert info.to_csa.include?("$TIME_LIMIT:00:00+05")
    end
  end
end
