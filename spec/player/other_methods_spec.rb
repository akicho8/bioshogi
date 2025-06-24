require "spec_helper"

RSpec.describe Bioshogi::Player::OtherMethods do
  it "bare_king?" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_human("△51玉 △22角 ▲28飛")
    assert { !container.player_at(:white).bare_king? }
    container.execute("▲22飛成")
    assert { container.player_at(:white).bare_king? }
  end
end
