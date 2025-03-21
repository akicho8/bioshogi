require "spec_helper"

describe Bioshogi::V do
  it "+" do
    assert { (Bioshogi::V[5, 6] + Bioshogi::V[2, 3]) == Bioshogi::V[7, 9]   }
    assert { (Bioshogi::V[5, 6] + 10)      == Bioshogi::V[15, 16] }
  end

  it "*" do
    assert { (Bioshogi::V[5, 6] * Bioshogi::V[2, 3]) == Bioshogi::V[10, 18] }
    assert { (Bioshogi::V[5, 6] * 10)      == Bioshogi::V[50, 60] }
  end

  it "==" do
    assert { Bioshogi::V[1, 2] == Bioshogi::V[1, 2] }
  end

  it "to_a" do
    assert { Bioshogi::V[5, 6].to_a == [5, 6] }
  end

  it "to_s" do
    assert { Bioshogi::V[5, 6].to_s == "[5, 6]" }
  end

  it "inspect" do
    assert { Bioshogi::V[5, 6].inspect == "<[5, 6]>" }
  end

  it "hash, eql?" do
    assert { { Bioshogi::V[5, 6] => true }[Bioshogi::V[5, 6]] }
  end

  it "<=>" do
    assert { [Bioshogi::V[1, 2], Bioshogi::V[0, 3]].sort == [Bioshogi::V[0, 3], Bioshogi::V[1, 2]] }
  end

  it "-" do
    assert { -Bioshogi::V[1, 2] == Bioshogi::V[-1, -2] }
  end

  it "each" do
    assert { Bioshogi::V[1, 2].each }
  end

  it "collect" do
    assert { Bioshogi::V[2, 3].collect.to_a == [2, 3] }
  end

  it "collect" do
    assert { Bioshogi::V[2, 3].collect.to_a == [2, 3] }
  end
end
