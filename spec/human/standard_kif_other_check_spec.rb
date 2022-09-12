require "spec_helper"

module Bioshogi
  describe "バグが再発しないように確認するためのテスト" do
    def test1(str)
      xcontainer = Bioshogi::Xcontainer.new
      xcontainer.board.placement_from_shape(@board)
      xcontainer.next_player.execute(str)
      xcontainer.hand_logs.last.to_kif_ki2_csa
    end

    it "P3B_A 寄る(ことができる)駒が2枚以上なので「左右」＋「寄」" do
      @board = <<~EOT
+---------------------------+
| 玉 ・ 銀 龍v銀v玉 銀 銀 ・|
| ・ ・ ・ 金 ・ ・ 香 と ・|
| ・ ・ ・ ・ ・ 馬 ・ ・ 龍|
| ・ ・ ・ ・ ・ 桂 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ 歩|
| ・v歩 ・ ・ ・ 歩 ・ ・ ・|
|vとvと ・ ・ ・ ・ ・ ・ ・|
|vと ・vと ・ ・ ・ ・ ・ 香|
+---------------------------+
EOT
      assert { test1("9989TO")     == ["８九と(99)", "８九と右寄", "-9989TO"] }
      assert { test1("８九と(99)") == ["８九と(99)", "８九と右寄", "-9989TO"] }
      assert { test1("８九と右寄") == ["８九と(99)", "８九と右寄", "-9989TO"] }
    end

    it "P3B, P3C △の手番で来れる駒が3枚あって右下から斜め左上に移動する" do
      @board = <<~EOT
+---------------------------+
|v香 ・ ・ ・v金 ・v金v桂v玉|
| ・ ・ ・ ・v金 ・ ・v銀v香|
|v歩 ・v桂v歩 ・ ・ ・v歩v歩|
| 歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・v歩 ・ ・ ・|
| ・ ・ ・ ・ ・ ・ 飛 歩 ・|
| ・ 歩 ・ ・ ・ 歩 桂 ・ 歩|
| ・ ・ ・ ・ 歩 ・ 馬 玉 ・|
| 香 桂 ・ ・ ・ ・ ・ ・ 香|
+---------------------------+
EOT
      assert { test1("４二金右上") == ["４二金(51)", "４二金右上", "-5142KI"] }
    end
  end
end
