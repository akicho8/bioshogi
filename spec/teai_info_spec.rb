require_relative "spec_helper"

module Bushido
  describe TeaiInfo do
    it "black_mini_soldiers" do
      TeaiInfo["平手"].black_mini_soldiers.collect(&:name).should == ["９七歩", "９九香", "８七歩", "８八角", "８九桂", "７七歩", "７九銀", "６七歩", "６九金", "５七歩", "５九玉", "４七歩", "４九金", "３七歩", "３九銀", "２七歩", "２八飛", "２九桂", "１七歩", "１九香"]
    end

    it "▲が平手で△が香落ちなので「香落ち」だと判断できる" do
      mediator = Mediator.new
      mediator.board_reset_for_text(<<~EOT)
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂 ・|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
      mediator.board.teai_name.should == "香落ち"
    end

    it "▲は平手状態だけど△は不明" do
      mediator = Mediator.new
mediator.board_reset_for_text(<<~EOT)
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀 ・ ・|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
      mediator.board.teai_name.should == nil
    end

    it "▲は「香落ち」だけど後手は平手状態ではないので正式な手合い名は出せない" do
      mediator = Mediator.new
      mediator.board_reset_for_text(<<~EOT)
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂 ・|一
| ・v飛 ・ ・ ・ ・ ・v角 ・|二
|v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| ・ 桂 銀 金 玉 金 銀 桂 香|九
+---------------------------+
EOT
      mediator.board.teai_name.should == nil
    end
  end
end
