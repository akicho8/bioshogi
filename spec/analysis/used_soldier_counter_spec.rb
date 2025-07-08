require "spec_helper"

RSpec.describe Bioshogi::Analysis::UsedSoldierCounter do
  it "to_s" do
    e = Bioshogi::Analysis::UsedSoldierCounter.new
    e.update(Bioshogi::Soldier.from_str("▲55飛"))
    e.to_s.include?("飛1")
  end
end
