require "spec_helper"

module Bioshogi
  describe "二歩" do
    it "works" do
      sfen = "position sfen 4k4/9/4p4/9/9/9/4P4/9/4K4 b P 1 moves 5g5f 5c5d P*5e"
      assert { Parser.parse(sfen).to_sfen rescue $!.class == DoublePawnCommonError }
      assert { Parser.parse(sfen, validate_double_pawn_skip: true).to_sfen == sfen }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.81824 seconds, 99.4% of total time):
# >>   二歩 works
# >>     0.81824 seconds -:5
# >> 
# >> Finished in 0.82352 seconds (files took 1.47 seconds to load)
# >> 1 example, 0 failures
# >> 
