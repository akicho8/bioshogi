require "spec_helper"

RSpec.describe "入玉宣言時の点数" do
  it "works" do
    container = Bioshogi::Container::Basic.new
    container.placement_from_bod(<<~EOT)
    後手の持駒：歩 角
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    | 飛 と と と と ・ ・ ・ 玉|
    | と と と と ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    | 歩 ・ ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    |v歩 ・ ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    |vとvとvとvとvと ・ ・ ・ ・|
    |v飛vとvとvとvと ・ ・ ・ v玉|
    +---------------------------+
      先手の持駒：歩歩
    EOT
    assert { container.player_at(:black).ek_score_without_cond == 15 }
    assert { container.player_at(:black).ek_score_with_cond == nil }
    assert { container.player_at(:white).ek_score_without_cond == 20 }
    assert { container.player_at(:white).ek_score_with_cond == 20 }
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> .
# >>
# >> Bioshogi::Top 1 slowest examples (0.01991 seconds, 87.2% of total time):
# >>   入玉宣言時の点数 works
# >>     0.01991 seconds -:5
# >>
# >> Bioshogi::Finished in 0.02282 seconds (files took 0.59605 seconds to load)
# >> 1 example, 0 failures
# >>
