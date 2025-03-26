require "spec_helper"

RSpec.describe Bioshogi::Formatter::AkfBuilder do
  it "works" do
    assert { Bioshogi::Parser.parse("68S").to_akf }
  end
end
