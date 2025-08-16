require "spec_helper"

RSpec.describe Bioshogi::Analysis::TacticInfo do
  it "works" do
    assert { Bioshogi::Analysis::TacticInfo.fetch(:attack) }
  end

  it "#lookup" do
    assert { Bioshogi::Analysis::TacticInfo["戦法"].key == :attack }
  end
end
