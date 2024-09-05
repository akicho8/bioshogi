require "spec_helper"

module Bioshogi
  RSpec.describe do
    it "5341NK だけでは判断が難しい例" do
      container = Container::Basic.new
      container.placement_from_preset("平手")
      container.execute("７六歩")
      container.execute("３四歩")
      container.execute("７七桂")
      container.execute("８四歩")
      container.execute("６五桂")
      container.execute("３二金")
      container.execute("５三桂")
      container.execute("８五歩")
      container.execute("5341NK") # 元位置の 53 の地点の駒を調べてもらい、成っていないのであれば NK は「４一桂成」で、成っていれば「４一成銀」になる
      expect(container.to_s).to eq(<<~EOT)
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉 圭v銀v桂v香|一
| ・v飛 ・ ・ ・ ・v金v角 ・|二
|v歩 ・v歩v歩 ・v歩 ・v歩v歩|三
| ・ ・ ・ ・ ・ ・v歩 ・ ・|四
| ・v歩 ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 ・ 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：歩
手数＝9 ▲４一桂成(53) まで
後手番
EOT
    end

    it "基本" do
      container = Container::Basic.new
      container.placement_from_preset("平手")
      container.execute("7776FU")
      expect(container.to_s).to eq(<<~EOT)
後手の持駒：なし
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
| 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
先手の持駒：なし
手数＝1 ▲７六歩(77) まで
後手番
EOT
    end
  end
end
