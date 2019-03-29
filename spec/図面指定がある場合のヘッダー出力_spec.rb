require_relative "spec_helper"

module Bioshogi
  describe "図面指定がある場合のヘッダー出力" do
    it do
      mediator = Mediator.new
      mediator.board.placement_from_hash(black: "十枚落ち", white: "裸玉")

      # 平手で途中の状態
      mediator.turn_info.handicap = false
      info = Parser.parse("position #{mediator.to_long_sfen}")
      assert { info.to_ki2 == <<~EOT }
後手の持駒：なし
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
先手の持駒：なし

まで0手で後手の勝ち
EOT

      # 本当の駒落ち
      mediator = Mediator.new
      mediator.board.placement_from_hash(black: "十枚落ち", white: "裸玉")
      mediator.turn_info.handicap = true
      info = Parser.parse("position #{mediator.to_long_sfen}")
      assert { info.to_ki2 == <<~EOT }
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

まで0手で下手の勝ち
EOT
    end
  end
end
