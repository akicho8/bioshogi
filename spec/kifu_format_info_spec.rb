require "spec_helper"

RSpec.describe do
  it "works" do
    assert { Bioshogi::KifuFormatInfo[:kif].name == "KIF" }
  end
end
