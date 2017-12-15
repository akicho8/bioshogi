require_relative "../spec_helper"

module Bushido
  describe Parser::Base do
    describe "消費時間があるCSAからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT, skill_set_flag: false)
+7968GI,,T30
-3334FU,T1
+2726FU
-8384FU,T2
%TORYO,,,T1
EOT
        end

        it "to_csa" do
          @info.to_csa.should == <<~EOT
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
          @info.to_kif.should == <<~EOT
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
          @info = Parser.parse(<<~EOT, skill_set_flag: false)
+7968GI,T30
-3334FU,T1
+2726FU
-8384FU,T2
%TORYO
EOT
        end

        it "to_csa" do
          @info.to_csa.should == <<~EOT
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
          @info.to_kif.should == <<~EOT
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
