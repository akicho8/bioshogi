require "spec_helper"

RSpec.describe Bioshogi::Analysis::GroupInfo do
  it "values" do
    assert { Bioshogi::Analysis::GroupInfo["右玉"].values.collect(&:key).include?(:"雁木右玉") }
    assert { Bioshogi::Analysis::GroupInfo["ロケット"].values.include?(Bioshogi::Analysis::TechniqueInfo[:"6段ロケット"]) }
  end
end
