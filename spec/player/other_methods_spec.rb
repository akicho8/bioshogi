require "spec_helper"

module Bioshogi
  describe Player::OtherMethods do
    it "zengoma?" do
      container = Container::Basic.new
      container.board.placement_from_human("△51玉 △22角 ▲28飛")
      assert { !container.player_at(:black).zengoma? }
      container.execute("▲22飛成")
      assert { container.player_at(:black).zengoma? }
    end
  end
end

