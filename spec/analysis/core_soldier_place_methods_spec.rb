require "spec_helper"

module Bioshogi
  module Analysis
    describe CoreSoldierPlaceMethods do
      it "core_soldier_places_hash" do
        board = Board.create_by_preset("平手")
        assert { board.core_soldier_places_for(:black, :rook)   == Place["28"] }
        assert { board.core_soldier_places_for(:black, :king)   == Place["59"] }
        assert { board.core_soldier_places_for(:black, :bishop) == Place["88"] }
        assert { board.core_soldier_places_for(:black, :pawn)   == nil }
        assert { board.core_soldier_places_for(:white, :rook)   == Place["82"] }
        assert { board.core_soldier_places_for(:white, :king)   == Place["51"] }
        assert { board.core_soldier_places_for(:white, :bishop) == Place["22"] }
        assert { board.core_soldier_places_for(:white, :pawn)   == nil }
        
        board.safe_delete_on(Place["59"])
        assert { board.core_soldier_places_for(:black, :king) == nil }
      end
    end
  end
end
