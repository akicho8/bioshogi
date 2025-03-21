require "spec_helper"

describe Bioshogi::Yomiage::KanjiInfo do
  it "works" do
    assert { Bioshogi::Yomiage::KanjiInfo.fetch("不成") }
  end
end
