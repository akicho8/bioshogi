require_relative "spec_helper"

module Warabi
  describe HandLog do
    it do
      move_hand = MoveHand.create(soldier: Soldier.from_str("▲６八銀"), origin_soldier: Soldier.from_str("▲７九銀"))
      object = HandLog.new(moved_hand: move_hand, candidate: [])
      object.to_kif.should == "６八銀(79)"
      object.to_ki2.should == "６八銀"
      object.to_csa.should == "+7968GI"
      object.to_sfen.should == "7i6h"
    end
  end
end
