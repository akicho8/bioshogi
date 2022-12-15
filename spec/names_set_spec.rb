require "spec_helper"

module Bioshogi
  describe "names_set" do
    it "works" do
      info = Parser.parse("position sfen 4k4/9/9/9/9/9/PPPPPPPPP/9/4K4 w - 1")
      info.exporter.names_set(black: "alice", white: "bob")
      expect(info.to_ki2).to eq(<<~EOT)
上手：bob
下手：alice
下手の備考：居飛車, 相居飛車, 背水の陣
上手の備考：居飛車, 相居飛車
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・v玉 ・ ・ ・ ・|一
| ・ ・ ・ ・ ・ ・ ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ ・ ・ ・ ・ ・ ・ ・ ・|八
| ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
+---------------------------+
下手の持駒：なし
上手番

まで0手で下手の勝ち
EOT

      info = Parser.parse("position startpos")
      info.exporter.names_set(black: "alice", white: "bob")
      expect(info.to_ki2).to eq(<<~EOT)
先手：alice
後手：bob
先手の備考：居飛車, 相居飛車
後手の備考：居飛車, 相居飛車
手合割：平手

まで0手で後手の勝ち
EOT
    end
  end
end
