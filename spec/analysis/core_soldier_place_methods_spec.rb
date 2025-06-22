require "spec_helper"

RSpec.describe Bioshogi::Analysis::CoreSoldierPlaceMethods do
  it "core_soldier_places_hash" do
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
end
