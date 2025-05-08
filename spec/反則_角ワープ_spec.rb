require "spec_helper"

RSpec.describe "角ワープ" do
  it "works" do
    sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8h2b+"
    assert { Bioshogi::Parser.parse(sfen).to_sfen rescue $!.class == Bioshogi::SoldierWarpError }
    assert { Bioshogi::Parser.parse(sfen, warp_detect: false).to_sfen == sfen }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 7 / 15 Bioshogi::LOC (46.67%) covered.
# >> .
# >>
# >> Bioshogi::Top 1 slowest examples (0.72752 seconds, 99.3% of total time):
# >>   角ワープ works
# >>     0.72752 seconds -:5
# >>
# >> Bioshogi::Finished in 0.73261 seconds (files took 1.45 seconds to load)
# >> 1 example, 0 failures
# >>
