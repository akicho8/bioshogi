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
先手の囲い：
後手の囲い：
先手の戦型：
後手の戦型：嬉野流
手合割：平手
手数----指手---------消費時間--
   1 ７六歩(77)   (00:00/00:00:00)
   2 ４二銀(31)   (00:00/00:00:00)
*△戦型：嬉野流
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
先手の囲い：
後手の囲い：
先手の戦型：
後手の戦型：嬉野流
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
        @info.to_csa(board_expansion: true, strip: true).should == <<~EOT
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

    describe "消費時間があるCSAからの変換" do
      describe "投了の部分まで時間が指定されている場合" do
        before do
          @info = Parser.parse(<<~EOT, defense_form_check_skip: true)
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
EOT
        end
      end

      describe "投了の部分まで時間が指定がない場合" do
        before do
          @info = Parser.parse(<<~EOT, defense_form_check_skip: true)
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
先手の囲い：
後手の囲い：
先手の戦型：
後手の戦型：
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
先手の囲い：
後手の囲い：
先手の戦型：
後手の戦型：
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
先手の囲い：
後手の囲い：
先手の戦型：
後手の戦型：
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
        @info = Parser.parse(<<~EOT, defense_form_check_skip: true)
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦型
$TIME_LIMIT:6時間
' 手合割:香落ち
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
        @info.to_csa(strip: true).should == <<~EOT
V2.2
$EVENT:その他の棋戦
$START_TIME:1938/03/01
$OPENING:その他の戦型
$TIME_LIMIT:06:00+00
' 手合割:香落ち
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
手合割：香落ち
手数----指手---------消費時間--
   1 ３四歩(33)   (00:00/00:00:00)
   2 ７六歩(77)   (00:00/00:00:00)
   3 投了
EOT
      end
    end

    describe "「上手の持駒：なし」があって手合割がわかっているときは「上手の持駒」の部分は消しとく" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
上手の持駒：なし
下手の持駒：
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
EOT
      end

      it "to_kif" do
        @info.to_kif.should == <<~EOT
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
下手の囲い：
上手の囲い：
下手の戦型：
上手の戦型：
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
   2 投了
EOT
      end
    end

    describe "手合割が「三枚落ち」で図が指定されている場合" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：三枚落ち
上手：伊藤宗印
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂 ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし
下手：天満屋

△６二銀
        EOT
      end

      it "to_csa" do
        @info.to_csa(strip: true).should == <<~EOT
V2.2
' 手合割:三枚落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE *
P2 *  *  *  *  *  *  *  *  *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-7162GI
%TORYO
EOT
      end

      it "to_kif" do
        @info.to_kif.should == <<~EOT
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
下手の囲い：
上手の囲い：
下手の戦型：
上手の戦型：
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
   2 投了
EOT
      end
    end

    describe "手合割が「その他」で図が指定されている場合は一応駒落ちになる" do
      before do
        @info = Parser.parse(<<~EOT)
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金 ・v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし

△８四歩
        EOT
      end

      it "to_kif" do
        @info.to_kif.should == <<~EOT
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金 ・v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし
下手の囲い：
上手の囲い：
下手の戦型：
上手の戦型：
手数----指手---------消費時間--
   1 ８四歩(83)   (00:00/00:00:00)
   2 投了
EOT
      end

      it "to_csa" do
        @info.to_csa(strip: true).should == <<~EOT
V2.2
P1-KY-KE-GI-KI-OU-KI * -KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-8384FU
%TORYO
EOT
      end
    end
  end
end
