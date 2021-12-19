require "spec_helper"

module Bioshogi
  describe "ぴよ将棋の駒落ち駒KIFの読み込み" do
    it "works" do
      str = "
手合割：その他
上手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・v銀v金v玉v金v銀 ・ ・|一
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

上手番
手数----指手---------消費時間--
   1 ４二玉(51)
"
      info = Parser.parse(str)
      turn_info = info.initial_mediator.turn_info
      assert { turn_info.current_location.key == :white }
      assert { turn_info.location_call_name   == "上手" }
      assert { info.to_kif == <<~EOT }
手合割：六枚落ち
手数----指手---------消費時間--
   1 ４二玉(51)
   2 投了
まで1手で上手の勝ち
EOT
    end
  end
end
