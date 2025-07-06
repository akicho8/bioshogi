require "spec_helper"

RSpec.describe "used_soldier_counter" do
  it "works" do
    info = Bioshogi::Parser.parse(<<~EOT)
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

    container = info.container

    assert { container.player_at(:black).used_soldier_counter.to_h == { :B0 => 2 } }
    assert { container.player_at(:white).used_soldier_counter.to_h == { :S0 => 1 } }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> .
# >>
# >> Bioshogi::Top 1 slowest examples (0.1277 seconds, 91.9% of total time):
# >>   used_piece_counts works
# >>     0.1277 seconds -:5
# >>
# >> Bioshogi::Finished in 0.13901 seconds (files took 2.73 seconds to load)
# >> 1 example, 0 failures
# >>
