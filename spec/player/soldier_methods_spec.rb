require "spec_helper"

RSpec.describe Bioshogi::Player::SoldierMethods do
  before do
    @container = Bioshogi::Container::Basic.new
    @container.board.placement_from_human("▲53玉 ▲23飛 △51玉 △22角")
  end

  it "soldiers" do
    assert { @container.player_at(:black).soldiers.collect(&:name) == ["▲５三玉", "▲２三飛"] }
  end

  it "king_soldier" do
    assert { @container.player_at(:black).king_soldier.name == "▲５三玉" }
  end

  it "to_s_soldiers" do
    assert { @container.player_at(:black).to_s_soldiers == "２三飛 ５三玉" }
  end

  it "king_soldier_entered" do
    assert { @container.player_at(:black).king_soldier_entered? }
  end

  it "soldiers_ek_score" do
    assert { @container.player_at(:black).soldiers_ek_score == 5 }
  end

  it "many_soliders_are_in_the_opponent_area?" do
    assert { @container.player_at(:black).many_soliders_are_in_the_opponent_area? == false }
  end

  it "entered_soldiers" do
    assert { @container.player_at(:black).entered_soldiers.collect(&:name) == ["▲２三飛"] }
  end
end
