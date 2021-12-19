require "spec_helper"

module Bioshogi
  describe "駒落ちCSA棋譜からの変換" do
    before do
      @info = Parser.parse(<<~EOT, skill_monitor_enable: false)
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
        assert { @info.to_csa == <<~EOT }
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
      assert { @info.to_kif == <<~EOT }
棋戦：その他の棋戦
開始日時：1938/03/01
戦型：その他の戦型
持ち時間：6時間
手合割：香落ち
手数----指手---------消費時間--
   1 ３四歩(33)
   2 ７六歩(77)
   3 投了
まで2手で下手の勝ち
EOT
    end
  end

  describe "(1) 平手初期配置と駒落ち" do
    it "落とす駒が明記されているケース" do
      info = Parser.parse(<<~EOT)
V2.2
PI82HI22KA
-
-3334FU
%TORYO
EOT
      assert { info.to_csa == <<~EOT }
V2.2
' 手合割:二枚落ち
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 *  *  *  *  *  *  *  *  *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
-
-3334FU
%TORYO
EOT
    end

    it "表記が間違っている" do
      expect { Parser.parse("V2.2,PI82HI22OU").to_csa }.to raise_error(SyntaxDefact)
    end
  end

  describe "(3) 駒別単独表現" do
    it do
      Parser.parse("V2.2,P-51OU,P+53KI00GI,P-00AL,-,-5141OU,+0052GI").to_csa == <<~EOT
V2.2
P1 *  *  *  * -OU *  *  *  *
P2 *  *  *  *  *  *  *  *  *
P3 *  *  *  * +KI *  *  *  *
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7 *  *  *  *  *  *  *  *  *
P8 *  *  *  *  *  *  *  *  *
P9 *  *  *  *  *  *  *  *  *
P+00GI
P-00HI00HI00KA00KA00KI00KI00KI00GI00GI00GI00KE00KE00KE00KE00KY00KY00KY00KY00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU00FU
-
-5141OU
+0052GI
%TORYO
EOT
    end
  end
end
