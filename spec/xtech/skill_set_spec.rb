require "spec_helper"

module Bioshogi
  module Xtech
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

      describe SkillSet::List do
        it "全部入り" do
          assert { @skill_set.defense_infos.collect(&:key) == [:"片美濃囲い", :"銀美濃", :"ダイヤモンド美濃"] }
        end

        it "「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する" do
          assert { @skill_set.defense_infos.normalize.collect(&:key) == [:"ダイヤモンド美濃"] }
        end

        it "別名を足したい場合" do
          assert { @skill_set.attack_infos.normalize.flat_map {|e|[e.key, *e.alias_names]} == [:"中田功XP", "コーヤン流", :"嬉野流"] }
        end

        it "defense_infos内でエイリアスを含めたすべての名前を取得" do
          assert { @skill_set.defense_infos.normalized_names_with_alias == ["ダイヤモンド美濃"] }
        end
      end

      it "all" do
        assert { @skill_set.collect(&:size) == [3, 2, 0, 1] }
      end

      it "エイリアスを含めたすべての名前を取得" do
        assert { @skill_set.normalized_names_with_alias == ["ダイヤモンド美濃", "中田功XP", "コーヤン流", "嬉野流", "入玉"] }
      end
    end
  end
  # >> ......
  # >>
  # >> Top 6 slowest examples (0.01322 seconds, 69.1% of total time):
  # >>   Bioshogi::SkillSet 全部入り
  # >>     0.01201 seconds -:15
  # >>   Bioshogi::SkillSet 「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する
  # >>     0.00031 seconds -:19
  # >>   Bioshogi::SkillSet エイリアスを含めたすべての名前を取得
  # >>     0.00028 seconds -:35
  # >>   Bioshogi::SkillSet 別名を足したい場合
  # >>     0.00022 seconds -:23
  # >>   Bioshogi::SkillSet defense_infos内でエイリアスを含めたすべての名前を取得
  # >>     0.00022 seconds -:31
  # >>   Bioshogi::SkillSet all
  # >>     0.00018 seconds -:27
  # >>
  # >> Finished in 0.01911 seconds (files took 1.67 seconds to load)
  # >> 6 examples, 0 failures
  # >>
end
