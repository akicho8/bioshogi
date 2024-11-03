require "spec_helper"

module Bioshogi
  describe V do
    it ".around_vectors" do
      assert { V.around_vectors }
    end

    it ".ikkenryu_vectors" do
      assert { V.ikkenryu_vectors }
    end

    it ".keima_ways" do
      assert { V.keima_ways }
    end

    it "+" do
      assert { (V[5, 6] + V[2, 3]) == V[7, 9]   }
      assert { (V[5, 6] + 10)      == V[15, 16] }
    end

    it "*" do
      assert { (V[5, 6] * V[2, 3]) == V[10, 18] }
      assert { (V[5, 6] * 10)      == V[50, 60] }
    end

    it "==" do
      assert { V[1, 2] == V[1, 2] }
    end

    it "to_a" do
      assert { V[5, 6].to_a == [5, 6] }
    end

    it "to_s" do
      assert { V[5, 6].to_s == "[5, 6]" }
    end

    it "inspect" do
      assert { V[5, 6].inspect == "<[5, 6]>" }
    end

    it "hash, eql?" do
      assert { { V[5, 6] => true }[V[5, 6]] }
    end

    it "<=>" do
      assert { [V[1, 2], V[0, 3]].sort == [V[0, 3], V[1, 2]] }
    end

    it "-" do
      assert { -V[1, 2] == V[-1, -2] }
    end

    it "each" do
      assert { V[1, 2].each }
    end

    it "collect" do
      assert { V[2, 3].collect.to_a == [2, 3] }
    end

    it "collect" do
      assert { V[2, 3].collect.to_a == [2, 3] }
    end
  end
end
