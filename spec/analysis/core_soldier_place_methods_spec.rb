require "spec_helper"

describe Bioshogi::Analysis::CoreSoldierPlaceMethods do
  it "core_soldier_places_hash" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.core_soldier_places_for(:black, :rook)   == Bioshogi::Place["28"] }
    assert { board.core_soldier_places_for(:black, :king)   == Bioshogi::Place["59"] }
    assert { board.core_soldier_places_for(:black, :bishop) == Bioshogi::Place["88"] }
    assert { board.core_soldier_places_for(:black, :pawn)   == nil }
    assert { board.core_soldier_places_for(:white, :rook)   == Bioshogi::Place["82"] }
    assert { board.core_soldier_places_for(:white, :king)   == Bioshogi::Place["51"] }
    assert { board.core_soldier_places_for(:white, :bishop) == Bioshogi::Place["22"] }
    assert { board.core_soldier_places_for(:white, :pawn)   == nil }

    board.safe_delete_on(Bioshogi::Place["59"])
    assert { board.core_soldier_places_for(:black, :king) == nil }
  end
end
