require "spec_helper"

module Bioshogi
  describe "図面指定がある場合のヘッダー出力" do
    it "平手" do
      mediator = Mediator.new
      mediator.board.placement_from_preset("裸玉")
      mediator.execute("58玉")
      mediator.execute("52玉")

      mediator.turn_info.handicap = false
      info = Parser.parse("position #{mediator.to_snapshot_sfen}")
      assert { info.to_ki2 == <<~EOT }
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・v玉 ・ ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ 玉 ・ ・ 飛 ・|八
| 香 桂 銀 金 ・ 金 銀 桂 香|九
+---------------------------+
先手の持駒：なし
先手番

まで0手で後手の勝ち
EOT
    end

    it "駒落ち" do
      mediator = Mediator.new
      mediator.board.placement_from_preset("裸玉")
      mediator.execute("58玉")
      mediator.execute("52玉")

      mediator.turn_info.handicap = true
      info = Parser.parse("position #{mediator.to_snapshot_sfen}")
      assert { info.to_ki2 == <<~EOT }
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・ ・|一
| ・ ・ ・ ・v玉 ・ ・ ・ ・|二
| ・ ・ ・ ・ ・ ・ ・ ・ ・|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ 玉 ・ ・ 飛 ・|八
| 香 桂 銀 金 ・ 金 銀 桂 香|九
+---------------------------+
下手の持駒：なし
上手番

まで0手で下手の勝ち
EOT
    end
  end
end
