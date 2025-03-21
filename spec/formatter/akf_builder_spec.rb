require "spec_helper"

describe Bioshogi::Formatter::AkfBuilder do
  it "works" do
    assert { Bioshogi::Parser.parse("68S").to_akf }
  end
end
