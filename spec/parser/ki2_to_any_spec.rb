require "spec_helper"

RSpec.describe Bioshogi::Parser::Base do
  describe "KI2からの変換" do
    before do
      @info = Bioshogi::Parser.parse(<<~EOT)
      場所：(場所)
      先手：(先手)
      後手：(後手)
      ▲７六歩 △４二銀 ▲２六歩 △５四歩 ▲２五歩 △５三銀 ▲２四歩 △同　歩 ▲５六歩 △３二金
      EOT
    end

    it "to_kif" do
      expect(@info.to_kif).to eq(<<~EOT)
      場所：(場所)
      先手：(先手)
      後手：(後手)
      後手の戦法：嬉野流, 新嬉野流
      先手の備考：居飛車, 短手数
      後手の備考：対居飛車, 短手数
      後手の棋風：王道
      手合割：平手
      手数----指手---------消費時間--
         1 ７六歩(77)
         2 ４二銀(31)
      *△戦法：嬉野流
         3 ２六歩(27)
      *▲備考：居飛車
         4 ５四歩(53)
         5 ２五歩(26)
         6 ５三銀(42)
      *△戦法：新嬉野流
         7 ２四歩(25)
         8 ２四歩(23)
         9 ５六歩(57)
        10 ３二金(41)
        11 投了
      まで10手で後手の勝ち
      EOT
    end

    it "to_ki2" do
      expect(@info.to_ki2).to eq(<<~EOT)
      場所：(場所)
      先手：(先手)
      後手：(後手)
      後手の戦法：嬉野流, 新嬉野流
      先手の備考：居飛車, 短手数
      後手の備考：対居飛車, 短手数
      後手の棋風：王道
      手合割：平手

      ▲７六歩 △４二銀 ▲２六歩 △５四歩 ▲２五歩 △５三銀 ▲２四歩 △同　歩
      ▲５六歩 △３二金
      まで10手で後手の勝ち
      EOT
    end

    it "to_csa" do
      expect(@info.to_csa).to eq(<<~EOT)
V2.2
N+(先手)
N-(後手)
$SITE:(場所)
' 手合割:平手
PI
+
+7776FU
-3142GI
+2726FU
-5354FU
+2625FU
-4253GI
+2524FU
-2324FU
+5756FU
-4132KI
%TORYO
EOT
      end

      it "to_csa(board_expansion: true)" do
        expect(@info.to_csa(board_expansion: true, strip: true)).to eq(<<~EOT)
V2.2
N+(先手)
N-(後手)
$SITE:(場所)
' 手合割:平手
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
+7776FU
-3142GI
+2726FU
-5354FU
+2625FU
-4253GI
+2524FU
-2324FU
+5756FU
-4132KI
%TORYO
EOT
    end
  end

  describe "駒落ちのKI2からBioshogi::SFEN変換の際に後手番から開始する" do
    before do
      @info = Bioshogi::Parser.parse(<<~EOT)
      手合割：香落ち
      下手：中井捨吉
      上手：寺田梅吉
      △３四歩
      EOT
    end
    it "to_sfen" do
      expect(@info.to_sfen).to eq("position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 3c3d")
    end
  end
end
