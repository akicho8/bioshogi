require_relative "spec_helper"

module Bushido
  describe AttackInfo do
    it "新米長玉" do
      info = Parser.parse("▲７六歩 △６二玉")
      info.header_part_string.include?("後手の戦型：新米長玉").should == true
      info.mediator.player_at(:white).attack_infos.collect(&:name).should == ["新米長玉"]
    end

    it "skill_group_info" do
      AttackInfo.first.skill_group_info.key.should == :attack
    end
  end
end
