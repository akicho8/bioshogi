require "spec_helper"

RSpec.describe Bioshogi::Analysis::SkillSet do
  before do
    @skill_set = Bioshogi::Analysis::SkillSet.new
    @skill_set.defense_infos << Bioshogi::Analysis::DefenseInfo["片美濃囲い"]
    @skill_set.defense_infos << Bioshogi::Analysis::DefenseInfo["銀美濃"]
    @skill_set.defense_infos << Bioshogi::Analysis::DefenseInfo["ダイヤモンド美濃"]
    @skill_set.attack_infos << Bioshogi::Analysis::AttackInfo["コーヤン流三間飛車"]
    @skill_set.attack_infos << Bioshogi::Analysis::AttackInfo["嬉野流"]
    @skill_set.note_infos << Bioshogi::Analysis::NoteInfo["入玉"]
  end

  describe Bioshogi::Analysis::SkillSet::List do
    it "全部入り" do
      assert { @skill_set.defense_infos.collect(&:key) == [:"片美濃囲い", :"銀美濃", :"ダイヤモンド美濃"] }
    end

    it "「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する" do
      assert { @skill_set.defense_infos.normalize.collect(&:key) == [:"ダイヤモンド美濃"] }
    end

    it "defense_infos内でエイリアスを含めたすべての名前を取得" do
      assert { @skill_set.defense_infos.normalized_names_with_alias == ["ダイヤモンド美濃"] }
    end
  end

  it "all" do
    assert { @skill_set.collect(&:size) == [3, 2, 0, 1] }
  end

  it "エイリアスを含めたすべての名前を取得" do
    assert { @skill_set.normalized_names_with_alias == ["ダイヤモンド美濃", "コーヤン流三間飛車", "コーヤン流", "中田功XP", "嬉野流", "入玉"] }
  end

  it "代表とする棋風" do
    assert { @skill_set.main_style_info.key == :"変態" }
  end
end
