require_relative "../spec_helper"

module Bushido
  describe "駒落ちCSA棋譜からの変換" do
    before do
      @info = Parser.parse(<<~EOT, skill_set_flag: false)
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
まで2手で下手の勝ち
EOT
    end
  end
end
