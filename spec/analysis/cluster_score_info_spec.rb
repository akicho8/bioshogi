require "spec_helper"

RSpec.describe Bioshogi::Analysis::ClusterScoreInfo do
  it "works" do
    assert { Bioshogi::Analysis::ClusterScoreInfo.collect(&:min_score) }
  end
end
