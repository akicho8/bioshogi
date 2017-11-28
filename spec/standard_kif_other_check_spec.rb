require_relative "spec_helper"

module Bushido
  describe "バグが再発しないように確認するためのテスト" do
    def test1(str)
      mediator = Bushido::Mediator.new
      mediator.board_reset_for_text(<<~EOT)
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
      mediator.next_player.execute(str)
      mediator.hand_logs.last.to_kif_ki2_csa
    end

    it "P3B_A 寄る(ことができる)駒が2枚以上なので「左右」＋「寄」" do
      test1("9989TO").should     == ["８九と(99)", "８九と右寄", "-9989TO"]
      test1("８九と(99)").should == ["８九と(99)", "８九と右寄", "-9989TO"]
      test1("８九と右寄").should == ["８九と(99)", "８九と右寄", "-9989TO"]
    end
  end
end
