require "spec_helper"

RSpec.describe Bioshogi::Analysis::TacticInfo do
  it "works" do
    assert { Bioshogi::Analysis::TacticInfo.fetch(:attack) }
  end
end
