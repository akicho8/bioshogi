require "spec_helper"

describe "発動手数のテーブル生成", tactic: true do
  it "works" do
    assert { Bioshogi::Analysis::TacticHitTurnTableGenerator.new.to_h }
  end
end
