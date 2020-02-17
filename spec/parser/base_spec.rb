require_relative "../spec_helper"

module Bioshogi
  describe Parser::Base do
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
        assert { @info.to_kif == <<~EOT }
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
   2 投了
まで1手で上手の勝ち
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
        assert { @info.to_csa == <<~EOT }
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
        assert { @info.to_kif == <<~EOT }
手合割：三枚落ち
上手：伊藤宗印
下手：天満屋
手数----指手---------消費時間--
   1 ６二銀(71)   (00:00/00:00:00)
   2 投了
まで1手で上手の勝ち
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
        assert { @info.to_kif == <<~EOT }
手合割：その他
上手の備考：居飛車
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
上手番
手数----指手---------消費時間--
   1 ８四歩(83)   (00:00/00:00:00)
*△備考：居飛車
   2 投了
まで1手で上手の勝ち
EOT
      end

      it "to_csa" do
        assert { @info.to_csa == <<~EOT }
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
