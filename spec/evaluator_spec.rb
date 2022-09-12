require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      xcontainer = Xcontainer.new
      xcontainer.board.placement_from_human("▲９七歩")
     assert { xcontainer.player_at(:black).evaluator.score >= 1 }
    end
  end
end
