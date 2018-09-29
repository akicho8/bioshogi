require_relative "spec_helper"

module Warabi
  describe HandLog do
    it do
      move_hand = MoveHand.create(soldier: Soldier.from_str("▲６八銀"), origin_soldier: Soldier.from_str("▲７九銀"))
      object = HandLog.new(move_hand: move_hand, candidate: [])
      assert { object.to_kif == "６八銀(79)" }
      assert { object.to_ki2 == "６八銀" }
      assert { object.to_csa == "+7968GI" }
      assert { object.to_sfen == "7i6h" }
    end

    it "to_kifuyomi" do
      mediator = Mediator.new
      mediator.placement_from_bod(<<~EOT)
      上手の持駒：飛
      ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
|v香v桂v銀v金v玉v金v銀v桂v香|一
| ・ ・ ・ ・v全 ・ ・v角 ・|二
|v歩 ・v歩v歩v歩v歩v歩 銀v歩|三
| ・ ・ ・ ・ 銀 ・ ・ ・ ・|四
| ・v飛 ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| 歩 歩 歩 歩 歩 歩 歩 ・ 歩|七
| ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
| 香 桂 銀 金 玉 金 ・ 桂 香|九
+---------------------------+
        下手の持駒：なし
      手数＝1

      後手番
      EOT
      mediator.execute("68銀")
      assert { mediator.hand_logs.last.to_kifuyomi }
      mediator.execute("55飛打")
      assert { mediator.hand_logs.last.to_kifuyomi }
      mediator.execute("34銀成")
      assert { mediator.hand_logs.last.to_kifuyomi }
      mediator.execute("57飛成")
      assert { mediator.hand_logs.last.to_kifuyomi }
      mediator.execute("53銀不成")
      assert { mediator.hand_logs.last.to_kifuyomi }
      mediator.execute("同成銀")
      assert { mediator.hand_logs.last.to_kifuyomi }
    end
  end
end
