require "spec_helper"

module Bioshogi
  module Analysis
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

      it "代表とする棋風" do
        assert { @skill_set.main_style_info.key == :"準王道" }
      end
    end
  end
                                      end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 5 / 13 LOC (38.46%) covered.
# >> ..F....
# >> 
# >> Failures:
# >> 
# >>   1) Bioshogi::Analysis::SkillSet 代表とする棋風
# >>      Failure/Error: Unable to find - to read failed line
# >> 
# >>      NoMethodError:
# >>        undefined method `main_style_info' for #<Bioshogi::Analysis::SkillSet:0x0000000108c41040 @defense_infos=[<片美濃囲い>, <銀美濃>, <ダイヤモンド美濃>], @attack_infos=[<中田功XP>, <嬉野流>], @note_infos=[<入玉>]>
# >>      # -:43:in `block (3 levels) in <module:Analysis>'
# >>      # -:43:in `block (2 levels) in <module:Analysis>'
# >> 
# >> Top 7 slowest examples (0.01482 seconds, 58.6% of total time):
# >>   Bioshogi::Analysis::SkillSet all
# >>     0.00885 seconds -:34
# >>   Bioshogi::Analysis::SkillSet エイリアスを含めたすべての名前を取得
# >>     0.00116 seconds -:38
# >>   Bioshogi::Analysis::SkillSet Bioshogi::Analysis::SkillSet::List defense_infos内でエイリアスを含めたすべての名前を取得
# >>     0.00099 seconds -:29
# >>   Bioshogi::Analysis::SkillSet Bioshogi::Analysis::SkillSet::List 「ダイヤモンド美濃」に含まれる「片美濃囲い」と、親戚の「銀美濃」を除外する
# >>     0.00098 seconds -:21
# >>   Bioshogi::Analysis::SkillSet 代表とする棋風
# >>     0.00095 seconds -:42
# >>   Bioshogi::Analysis::SkillSet Bioshogi::Analysis::SkillSet::List 別名を足したい場合
# >>     0.00095 seconds -:25
# >>   Bioshogi::Analysis::SkillSet Bioshogi::Analysis::SkillSet::List 全部入り
# >>     0.00094 seconds -:17
# >> 
# >> Finished in 0.02527 seconds (files took 1.87 seconds to load)
# >> 7 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:42 # Bioshogi::Analysis::SkillSet 代表とする棋風
# >> 
