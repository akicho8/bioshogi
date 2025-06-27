require "spec_helper"

RSpec.describe Bioshogi::Parser::Base do
  describe "平手の盤面があるBioshogi::CSAからの変換" do
    before do
      @info = Bioshogi::Parser.parse(<<~EOT, analysis_feature: false)
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
      expect(@info.to_kif).to eq(<<~EOT)
      手合割：平手
      手数----指手---------消費時間--
         1 ６八銀(79)
         2 ３四歩(33)
         3 投了
      まで2手で後手の勝ち
      EOT
    end

    it "to_ki2" do
      expect(@info.to_ki2).to eq(<<~EOT)
      手合割：平手

      ▲６八銀 △３四歩
      まで2手で後手の勝ち
      EOT
    end

    it "to_csa" do
      expect(@info.to_csa).to eq(<<~EOT)
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
