require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      container = Container.create
      container.board.placement_from_human("▲９七歩")
     assert { container.player_at(:black).evaluator.score >= 1 }
    end
  end
end
