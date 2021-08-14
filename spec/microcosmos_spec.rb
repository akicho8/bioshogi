require "spec_helper"

module Bioshogi
  describe "ミクロコスモス" do
    it do
      bod = nil
      GC.start
      GC.disable
      ms = Benchmark.ms { bod = Parser.file_parse(Pathname(__dir__).join("../experiment/microcosmos.kif")).to_bod }
      GC.enable
      assert { ms < 1130 }
      assert { bod == <<~EOT }
後手の持駒：飛二 角 銀 桂二 香 歩三
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ と と と と 杏 ・|一
| ・v金 ・ ・ ・ ・ ・ ・ ・|二
| ・v桂 ・ ・v歩v歩v歩v歩 ・|三
| ・ ・ とv銀v金vと ・ ・ ・|四
|v馬v圭 香 ・ ・ ・ ・ 銀 ・|五
| ・ 歩 歩 ・ ・ ・ と ・ 香|六
| ・ ・ ・ ・ ・ ・ ・ ・ ・|七
| ・ ・ ・ ・ とv銀 歩 ・ ・|八
| ・ ・ ・ ・ ・ ・ 金 金v玉|九
+---------------------------+
先手の持駒：なし
手数＝1525 ▲２九金打 まで

後手番
EOT
    end
  end
end
