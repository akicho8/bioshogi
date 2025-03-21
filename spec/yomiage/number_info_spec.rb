require "spec_helper"

describe Bioshogi::Yomiage::NumberInfo do
  it "works" do
    assert { Bioshogi::Yomiage::NumberInfo.fetch("1") }
  end
end
