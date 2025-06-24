require "spec_helper"

RSpec.describe Bioshogi::Analysis::BoardPieceCountsMethods do
  it "soldiers_count" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.soldiers_count[:white][:bishop] == 1 }
    board.safe_delete_on(Bioshogi::Place["22"])
    assert { board.soldiers_count[:white][:bishop] == 0 }
  end

  it "soldiers_count_per_location" do
    board = Bioshogi::Board.create_by_preset("平手")
    assert { board.soldiers_count_per_location == { white: 20, black: 20 } }
    board.safe_delete_on(Bioshogi::Place["22"])
    assert { board.soldiers_count_per_location == { white: 19, black: 20 } }
  end
end
