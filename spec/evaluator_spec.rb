require_relative "spec_helper"

module Warabi
  describe do
    it do
      mediator = Mediator.new
      mediator.board.placement_from_human("▲９七歩")
      assert mediator.player_at(:black).evaluator.score >= 1
    end
  end
end
