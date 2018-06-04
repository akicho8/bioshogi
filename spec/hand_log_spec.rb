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
  end
end
