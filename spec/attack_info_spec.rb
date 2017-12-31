require_relative "spec_helper"

module Bushido
  describe AttackInfo do
    it "新米長玉" do
      info = Parser.parse("▲７六歩 △６二玉")
      info.header_part_string.include?("後手の戦型：新米長玉").should == true
      info.mediator.player_at(:white).attack_infos.collect(&:name).should == ["新米長玉"]
    end

    it "嬉野流" do
      info = Parser.parse("▲６八銀")
      info.header_part_string.include?("嬉野流").should == true
    end

    it "tactic_info" do
      AttackInfo.first.tactic_info.key.should == :attack
    end

    it "UFO銀" do
      
      pp AttackInfo["UFO銀"]
      
      AttackInfo["UFO銀"].name.should == "UFO銀"

      
    end
  end
end
