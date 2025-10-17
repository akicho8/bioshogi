require "spec_helper"

RSpec.describe do
  it "works" do
    assert { Bioshogi::Parser.parse("+\n%KACHI").to_kif.include?("持将棋")   }
    assert { Bioshogi::Parser.parse("+\n%JISHOGI").to_kif.include?("持将棋") }
  end
end
