require "spec_helper"

RSpec.describe Bioshogi::Hand::Move do
  it "特定の軸に絞った移動差分" do
    move_hand = Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△62玉"), origin_soldier: Bioshogi::Soldier.from_str("△51玉"))
    assert { move_hand.right_move_length ==  1 }
    assert { move_hand.left_move_length  == -1 }
    assert { move_hand.up_move_length    ==  1 }
    assert { move_hand.down_move_length  == -1 }
  end

  it "移動ベクトル" do
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲56玉")).move_vector == Bioshogi::V.up    }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲54玉")).move_vector == Bioshogi::V.down  }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲45玉")).move_vector == Bioshogi::V.left  }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("▲55玉"), origin_soldier: Bioshogi::Soldier.from_str("▲65玉")).move_vector == Bioshogi::V.right }

    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△56玉")).move_vector == Bioshogi::V.down  }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△54玉")).move_vector == Bioshogi::V.up    }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△45玉")).move_vector == Bioshogi::V.right }
    assert { Bioshogi::Hand::Move.create(soldier: Bioshogi::Soldier.from_str("△55玉"), origin_soldier: Bioshogi::Soldier.from_str("△65玉")).move_vector == Bioshogi::V.left  }
  end
end
