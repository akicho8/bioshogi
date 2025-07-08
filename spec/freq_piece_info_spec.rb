require "spec_helper"

RSpec.describe do
  it "works" do
    assert { Bioshogi::FreqPieceInfo["龍"].to_counts_key == :R1 }
  end
end
