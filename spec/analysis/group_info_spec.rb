require "spec_helper"

describe Bioshogi::Analysis::GroupInfo do
  it "values" do
    assert { Bioshogi::Analysis::GroupInfo.fetch("右玉").values.collect(&:key).include?(:"雁木右玉") }
  end
end
