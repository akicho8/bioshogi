require "spec_helper"

module Bioshogi
  RSpec.describe do
    it "works" do
      container = Container::Basic.new
      container.board.placement_from_human("▲９七歩")
     assert { container.player_at(:black).evaluator.score >= 1 }
    end
  end
end
