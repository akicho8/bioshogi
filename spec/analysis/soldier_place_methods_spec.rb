require "spec_helper"

RSpec.describe Bioshogi::Analysis::SoldierPlaceMethods do
  it "soldier_places_hash" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.soldiers_lookup(:black, :rook)   == [Bioshogi::Soldier.from_str("▲２八飛")] }
    assert { board.soldiers_lookup(:black, :king)   == [Bioshogi::Soldier.from_str("▲５九玉")] }
    assert { board.soldiers_lookup(:black, :bishop) == [Bioshogi::Soldier.from_str("▲８八角")] }
    assert { board.soldiers_lookup(:black, :pawn).many? }
    assert { board.soldiers_lookup(:white, :rook)   == [Bioshogi::Soldier.from_str("△８二飛")] }
    assert { board.soldiers_lookup(:white, :king)   == [Bioshogi::Soldier.from_str("△５一玉")] }
    assert { board.soldiers_lookup(:white, :bishop) == [Bioshogi::Soldier.from_str("△２二角")] }
    assert { board.soldiers_lookup(:white, :pawn).many? }

    board.safe_delete_on(Bioshogi::Place["59"])
    assert { board.soldiers_lookup(:black, :king)   == [] }
  end

  it "soldier_places_hash2" do
    board = Bioshogi::Board.create_by_human("△22馬▲88角")
    assert { board.soldiers_lookup2(:white, :bishop, true)  == [Bioshogi::Soldier.from_str("△２二馬")] }
    assert { board.soldiers_lookup2(:black, :bishop, false) == [Bioshogi::Soldier.from_str("▲８八角")] }
    assert{ board.soldiers_lookup2(:black, :rook, false)    == [] }
  end
end
