require_relative "../spec_helper"

module Bioshogi
  describe Parser::Base do
    describe "平手の盤面があるCSAからの変換" do
      before do
        @info = Parser.parse(<<~EOT)
V2.2
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
+7968GI
-3334FU
%TORYO
EOT
            end

      it "to_kif" do
        assert { @info.to_kif == <<~EOT }
先手の戦型：嬉野流
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:00/00:00:00)
*▲戦型：嬉野流
   2 ３四歩(33)   (00:00/00:00:00)
   3 投了
まで2手で後手の勝ち
EOT
      end

      it "to_ki2" do
        assert { @info.to_ki2 == <<~EOT }
先手の戦型：嬉野流
手合割：平手

▲６八銀 △３四歩
まで2手で後手の勝ち
EOT
      end

      it "to_csa" do
        assert { @info.to_csa == <<~EOT }
V2.2
' 手合割:平手
PI
+
+7968GI
-3334FU
%TORYO
EOT
      end
    end
  end
end
