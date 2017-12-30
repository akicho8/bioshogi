require_relative "spec_helper"

module Bushido
  describe SkillSet do
    before do
      @skill_set = SkillSet.new
      @skill_set.defense_infos << DefenseInfo["片美濃囲い"]
      @skill_set.defense_infos << DefenseInfo["銀美濃"]
      @skill_set.defense_infos << DefenseInfo["ダイヤモンド美濃"]
      @skill_set.defense_infos << DefenseInfo["坊主美濃"]
    end

    it "全部入り" do
      @skill_set.defense_infos.collect(&:key).should == [:"片美濃囲い", :"銀美濃", :"ダイヤモンド美濃", :"坊主美濃"]
    end

    it "「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する" do
      @skill_set.normalized_defense_infos.collect(&:key).should == [:"ダイヤモンド美濃", :"坊主美濃"]
    end

    it "それに別名を足す" do
      @skill_set.normalized_defense_infos.flat_map {|e|[e.key, *e.alias_names]}.should == [:"ダイヤモンド美濃", :"坊主美濃", "大山美濃"]
    end
  end
end
