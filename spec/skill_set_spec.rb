require "spec_helper"

module Bioshogi
  describe SkillSet do
    before do
      @skill_set = SkillSet.new
      @skill_set.defense_infos << DefenseInfo["片美濃囲い"]
      @skill_set.defense_infos << DefenseInfo["銀美濃"]
      @skill_set.defense_infos << DefenseInfo["ダイヤモンド美濃"]
      @skill_set.attack_infos << AttackInfo["中田功XP"]
      @skill_set.attack_infos << AttackInfo["嬉野流"]
      @skill_set.note_infos << NoteInfo["入玉"]
    end

    it "全部入り" do
      assert { @skill_set.defense_infos.collect(&:key) == [:"片美濃囲い", :"銀美濃", :"ダイヤモンド美濃"] }
    end

    it "「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する" do
      assert { @skill_set.defense_infos.normalize.collect(&:key) == [:"ダイヤモンド美濃"] }
    end

    it "別名を足したい場合" do
      assert { @skill_set.attack_infos.normalize.flat_map {|e|[e.key, *e.alias_names]} == [:"中田功XP", "コーヤン流", :"嬉野流"] }
    end

    it "all" do
      assert { @skill_set.collect(&:size) == [3, 2, 0, 1] }
    end
  end
end
