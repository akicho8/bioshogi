require "spec_helper"

module Bioshogi
  describe do
    it "works" do
      info = Parser.parse(<<~EOT)
      後手の持駒：
      ９ ８ ７ ６ ５ ４ ３ ２ １
      +---------------------------+
      |v香v桂v銀v金v玉v金v銀v桂v香|一
      | ・v飛 ・ ・ ・ ・ ・v角 ・|二
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
      | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
      | 香 桂 銀 金 玉 金 銀 桂 香|九
      +---------------------------+
        先手の持駒：
      22角成 同銀 55角打
      EOT

      mediator = info.mediator
      assert { mediator.player_at(:black).used_piece_counts == { [:bishop, false] => 2 } }
      assert { mediator.player_at(:white).used_piece_counts == { [:silver, false] => 1 } }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.33945 seconds, 98.5% of total time):
# >>   works
# >>     0.33945 seconds -:5
# >> 
# >> Finished in 0.34446 seconds (files took 1.3 seconds to load)
# >> 1 example, 0 failures
# >> 
