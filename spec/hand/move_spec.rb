require "spec_helper"

RSpec.describe Bioshogi::Hand::Move do
  it "移動差分" do
    move_hand = Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△62玉"), origin_soldier: Bioshogi::Soldier.from_str("△51玉"))
    assert { move_hand.right_move_length ==  1 }
    assert { move_hand.left_move_length  == -1 }
    assert { move_hand.up_move_length    ==  1 }
    assert { move_hand.down_move_length  == -1 }
  end
end
