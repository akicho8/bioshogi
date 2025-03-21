require "spec_helper"

describe do
  it "works" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_human("▲９七歩")
    assert { container.player_at(:black).evaluator.score >= 1 }
  end
end
