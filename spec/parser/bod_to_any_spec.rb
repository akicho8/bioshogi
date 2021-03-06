require_relative "../spec_helper"

module Bioshogi
  describe Parser::Base do
    describe "BODからの変換" do
      before do
        @info = Parser.parse(<<~EOT)
後手：ごて
後手の持駒：飛　角　金　銀　桂　香　歩四　
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂 ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ 馬 ・ ・ 龍 ・ ・|二
| ・ ・v玉 ・v歩 ・ ・ ・ ・|三
|v歩 ・ ・ ・v金 ・ ・ ・ ・|四
| ・ ・v銀 ・ ・ ・v歩 ・ ・|五
| ・ ・ ・ ・ 玉 ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩v歩 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| 香 桂v金 ・v金 ・ ・ 桂 香|九
+---------------------------+
先手：せんて
先手の持駒：銀二　歩四　
手数＝171  ▲６二角成  まで

後手番
        EOT
      end

      it "to_bod" do
        assert { @info.to_bod == <<~EOT }
後手の持駒：飛 角 金 銀 桂 香 歩四
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂 ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ 馬 ・ ・ 龍 ・ ・|二
| ・ ・v玉 ・v歩 ・ ・ ・ ・|三
|v歩 ・ ・ ・v金 ・ ・ ・ ・|四
| ・ ・v銀 ・ ・ ・v歩 ・ ・|五
| ・ ・ ・ ・ 玉 ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩v歩 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| 香 桂v金 ・v金 ・ ・ 桂 香|九
+---------------------------+
先手の持駒：銀二 歩四
手数＝171 まで

後手番
EOT
      end

      it "to_kif" do
        assert { @info.to_kif == <<~EOT }
後手：ごて
先手：せんて
後手の持駒：飛 角 金 銀 桂 香 歩四
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂 ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ 馬 ・ ・ 龍 ・ ・|二
| ・ ・v玉 ・v歩 ・ ・ ・ ・|三
|v歩 ・ ・ ・v金 ・ ・ ・ ・|四
| ・ ・v銀 ・ ・ ・v歩 ・ ・|五
| ・ ・ ・ ・ 玉 ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩v歩 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| 香 桂v金 ・v金 ・ ・ 桂 香|九
+---------------------------+
先手の持駒：銀二 歩四
後手番
手数----指手---------消費時間--
   1 投了
まで0手で先手の勝ち
EOT
      end
    end
  end
end
