require "spec_helper"

module Bioshogi
  describe "used_piece_counts" do
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

      xcontainer = info.xcontainer

      assert { xcontainer.player_at(:black).used_piece_counts == {"B0" => 2} }
      assert { xcontainer.player_at(:white).used_piece_counts == {"S0" => 1} }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 7 / 15 LOC (46.67%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.34134 seconds, 98.6% of total time):
# >>   used_piece_counts works
# >>     0.34134 seconds -:5
# >> 
# >> Finished in 0.3461 seconds (files took 1.69 seconds to load)
# >> 1 example, 0 failures
# >> 
