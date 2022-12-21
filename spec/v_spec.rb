require "spec_helper"

module Bioshogi
  describe V do
    it "works" do
      assert { (V[5, 6] * 10) == V[50, 60] }
    end

    it "*" do
      assert { (V[5, 6] * V[2, 3]) == V[10, 18] }
      assert { (V[5, 6] * 10)      == V[50, 60] }
    end

    it "to_a" do
      assert { V[5, 6].to_a == [5, 6] }
    end

    it "collect" do
      assert { V[5, 6].collect { |e| e * 10 } == V[50, 60] }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 5 / 13 LOC (38.46%) covered.
# >> .
# >>
# >> Top 1 slowest examples (0.00017 seconds, 2.6% of total time):
# >>   Bioshogi::V works
# >>     0.00017 seconds -:5
# >>
# >> Finished in 0.00664 seconds (files took 2.13 seconds to load)
# >> 1 example, 0 failures
# >>
