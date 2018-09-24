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
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "せんて、ろくはちぎん"       }
      assert { mediator.hand_logs.last.to_ki2           == "６八銀"                     }
      assert { mediator.hand_logs.last.to_kifuyomi      == "したて、ろくはちぎん"       }
      mediator.execute("55飛打")
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "ごて、ごーごーひしゃ打つ！" }
      assert { mediator.hand_logs.last.to_ki2           == "５五飛打"                   }
      assert { mediator.hand_logs.last.to_kifuyomi      == "うわて、ごーごーひしゃうつ" }
      mediator.execute("34銀成")
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "せんて、さんよんぎん成り"   }
      assert { mediator.hand_logs.last.to_ki2           == "３四銀成"                   }
      assert { mediator.hand_logs.last.to_kifuyomi      == "したて、さんよんぎんなり"   }
      mediator.execute("57飛成")
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "ごて、ごーななひしゃ成り"   }
      assert { mediator.hand_logs.last.to_ki2           == "５七飛成"                   }
      assert { mediator.hand_logs.last.to_kifuyomi      == "うわて、ごーななひしゃなり" }
      mediator.execute("53銀不成")
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "せんて、ごーさんぎん"       }
      assert { mediator.hand_logs.last.to_ki2           == "５三銀不成"                 }
      assert { mediator.hand_logs.last.to_kifuyomi      == "したて、ごーさんぎんふなり" }
      mediator.execute("同成銀")
      assert { mediator.hand_logs.last.hand.to_kifuyomi == "ごて、ごーさんなりぎん"     }
      assert { mediator.hand_logs.last.to_ki2           == "同全"                       }
      assert { mediator.hand_logs.last.to_kifuyomi      == "うわて、どうなりぎん"       }
    end
  end
end
