require_relative "../spec_helper"

module Bioshogi
  describe Parser::Base do
    it "-2725RYのときに候補が2つあるのでKI2にしたときに「△２五飛引成」になる" do
      info = Parser.parse("+7776FU,-3334FU,+2726FU,-4344FU,+2625FU,-2233KA,+5756FU,-8222HI,+5968OU,-2324FU,+2524FU,-3324KA,+2824HI,-2224HI,+0015KA,-0027HI,+0028FU,-2725RY")
      assert { info.to_ki2.include?("△２五飛引成") == true }
    end

    describe "消費時間があるCSAからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT, skill_monitor_enable: false)
+7968GI,,T30
-3334FU,T1
+2726FU
-8384FU,T2
%TORYO,,,T1
EOT
        end

        it "to_csa" do
          assert { @info.to_csa == <<~EOT }
V2.2
' 手合割:平手
PI
+
+7968GI,T30
-3334FU,T1
+2726FU,T0
-8384FU,T2
%TORYO,T1
EOT
        end

        it "to_kif" do
          assert { @info.to_kif == <<~EOT }
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
   2 ３四歩(33)   (00:01/00:00:01)
   3 ２六歩(27)   (00:00/00:00:30)
   4 ８四歩(83)   (00:02/00:00:03)
   5 投了         (00:01/00:00:31)
まで4手で後手の勝ち
EOT
        end
      end

      describe "投了の部分まで時間が指定がない場合" do
        before do
          @info = Parser.parse(<<~EOT, skill_monitor_enable: false)
+7968GI,T30
-3334FU,T1
+2726FU
-8384FU,T2
%TORYO
EOT
        end

        it "to_csa" do
          assert { @info.to_csa == <<~EOT }
V2.2
' 手合割:平手
PI
+
+7968GI,T30
-3334FU,T1
+2726FU,T0
-8384FU,T2
%TORYO
EOT
        end

        it "to_kif" do
          assert { @info.to_kif == <<~EOT }
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
   2 ３四歩(33)   (00:01/00:00:01)
   3 ２六歩(27)   (00:00/00:00:30)
   4 ８四歩(83)   (00:02/00:00:03)
   5 投了
まで4手で後手の勝ち
EOT
        end
      end
    end
  end
end
