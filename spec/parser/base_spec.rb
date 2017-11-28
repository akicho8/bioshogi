require_relative "../spec_helper"

module Bushido
  describe Parser::Base do
    describe "各種フォーマットへの変換" do
      before do
        @info = Parser.parse(<<~EOT)
        場所：(場所)
        先手：(先手)
        後手：(後手)
        ▲７六歩 △４二銀 ▲２六歩 △５四歩 ▲２五歩 △５三銀 ▲２四歩 △同　歩 ▲５六歩 △３二金
        EOT
      end

      it "to_kif" do
        @info.to_kif.should == <<~EOT
場所：(場所)
先手：(先手)
後手：(後手)
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)   (00:00/00:00:00)
   2 ４二銀(31)   (00:00/00:00:00)
   3 ２六歩(27)   (00:00/00:00:00)
   4 ５四歩(53)   (00:00/00:00:00)
   5 ２五歩(26)   (00:00/00:00:00)
   6 ５三銀(42)   (00:00/00:00:00)
   7 ２四歩(25)   (00:00/00:00:00)
   8 ２四歩(23)   (00:00/00:00:00)
   9 ５六歩(57)   (00:00/00:00:00)
  10 ３二金(41)   (00:00/00:00:00)
  11 投了
EOT
      end

      it "to_ki2" do
        @info.to_ki2.should == <<~EOT
場所：(場所)
先手：(先手)
後手：(後手)
手合割：平手

▲７六歩 △４二銀 ▲２六歩 △５四歩 ▲２五歩 △５三銀 ▲２四歩 △同　歩 ▲５六歩 △３二金
まで10手で後手の勝ち
EOT
      end

      it "to_csa" do
        @info.to_csa.should == <<~EOT
V2.2
N+(先手)
N-(後手)
$SITE:(場所)
" 手合割:平手
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
        @info.to_csa(board_expansion: true, strip: true).should == <<~EOT
V2.2
N+(先手)
N-(後手)
$SITE:(場所)
" 手合割:平手
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

    describe "消費時間があるCSAからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT)
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
" 手合割:平手
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
EOT
        end
      end

      describe "投了の部分まで時間が指定がない場合" do
        before do
          @info = Parser.parse(<<~EOT)
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
" 手合割:平手
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
EOT
        end
      end
    end

    describe "消費時間があるKIFからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
   2 ３四歩(33)   (00:01/00:00:01)
   3 ２六歩(27)   (00:00/00:00:30)
   4 ８四歩(83)   (00:02/00:00:03)
   5 投了         (00:01/00:00:31)
EOT
        end

        it "to_csa" do
          @info.to_csa.should == <<~EOT
V2.2
" 手合割:平手
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
EOT
        end
      end

      describe "投了の部分まで時間が指定がない場合" do
        before do
          @info = Parser.parse(<<~EOT)
手合割：平手
手数----指手---------消費時間--
   1 ６八銀(79)   (00:30/00:00:30)
   2 ３四歩(33)   (00:01/00:00:01)
   3 ２六歩(27)   (00:00/00:00:30)
   4 ８四歩(83)   (00:02/00:00:03)
   5 投了
EOT
        end

        it "to_csa" do
          @info.to_csa.should == <<~EOT
V2.2
" 手合割:平手
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
EOT
        end
      end
    end

    describe "駒落ちCSA棋譜からの変換" do
      before do
        @info = Parser.parse(<<~EOT)
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦型
$TIME_LIMIT:6時間
" 手合割:香落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE * 
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-3334FU
+7776FU
EOT
      end

      it "to_csa (本当は P 表記だけにしたい)" do
        @info.to_csa.should == <<~EOT
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦型
$TIME_LIMIT:6時間
" 手合割:香落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE * 
P2 * -HI *  *  *  *  * -KA * 
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  * 
P5 *  *  *  *  *  *  *  *  * 
P6 *  *  *  *  *  *  *  *  * 
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI * 
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-3334FU
+7776FU
%TORYO
EOT
      end

      it "to_kif" do
        @info.to_kif.should == <<~EOT
棋戦：その他の棋戦
開始日時：1938/03/01
戦型：その他の戦型
持ち時間：6時間
手合割：平手
手数----指手---------消費時間--
   1 ３四歩(33)   (00:00/00:00:00)
   2 ７六歩(77)   (00:00/00:00:00)
   3 投了
EOT
      end
    end
  end
end
