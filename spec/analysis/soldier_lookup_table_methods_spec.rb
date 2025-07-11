require "spec_helper"

RSpec.describe Bioshogi::Analysis::SoldierLookupTableMethods do
  it "soldier_lookup_hash1" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.soldiers_lookup1(:black, :rook)   == [Bioshogi::Soldier.from_str("▲２八飛")] }
    assert { board.soldiers_lookup1(:black, :king)   == [Bioshogi::Soldier.from_str("▲５九玉")] }
    assert { board.soldiers_lookup1(:black, :bishop) == [Bioshogi::Soldier.from_str("▲８八角")] }
    assert { board.soldiers_lookup1(:black, :pawn).many? }
    assert { board.soldiers_lookup1(:white, :rook)   == [Bioshogi::Soldier.from_str("△８二飛")] }
    assert { board.soldiers_lookup1(:white, :king)   == [Bioshogi::Soldier.from_str("△５一玉")] }
    assert { board.soldiers_lookup1(:white, :bishop) == [Bioshogi::Soldier.from_str("△２二角")] }
    assert { board.soldiers_lookup1(:white, :pawn).many? }

    board.safe_delete_on(Bioshogi::Place["59"])
    assert { board.soldiers_lookup1(:black, :king)   == [] }
  end

  it "soldier_lookup_hash2" do
    board = Bioshogi::Board.create_by_human("△22馬▲88角")
    assert { board.soldiers_lookup2(:white, :bishop, true)  == [Bioshogi::Soldier.from_str("△２二馬")] }
    assert { board.soldiers_lookup2(:black, :bishop, false) == [Bioshogi::Soldier.from_str("▲８八角")] }
    assert { board.soldiers_lookup2(:black, :rook, false)    == [] }
  end
end
