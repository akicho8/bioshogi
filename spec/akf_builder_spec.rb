require "spec_helper"

module Bioshogi
  describe Formatter::AkfBuilder do
    it "works" do
      assert { Parser.parse("68S").to_akf }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.92903 seconds, 99.3% of total time):
# >>   Bioshogi::AkfBuilder works
# >>     0.92903 seconds -:5
# >> 
# >> Finished in 0.93593 seconds (files took 2.58 seconds to load)
# >> 1 example, 0 failures
# >> 
