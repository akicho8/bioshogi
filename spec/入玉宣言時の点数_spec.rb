require "spec_helper"

module Bioshogi
  describe "入玉宣言時の点数" do
    it "works" do
      container = Container::Basic.new
      container.placement_from_bod(<<~EOT)
後手の持駒：歩 角
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| 飛 と ・ ・ 玉 ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| 歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v歩 ・ ・ ・v玉 ・ ・ ・ ・  |
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v飛vとvと ・ ・ ・ ・ ・ ・ |
+---------------------------+
先手の持駒：歩歩
EOT
      assert { container.players.collect(&:ek_score1) == [8, 13]    }
      assert { container.players.collect(&:ek_score2) == [nil, nil] }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 5 / 13 LOC (38.46%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.01399 seconds, 87.3% of total time):
# >>   入玉宣言時の点数 works
# >>     0.01399 seconds -:5
# >> 
# >> Finished in 0.01602 seconds (files took 0.54542 seconds to load)
# >> 1 example, 0 failures
# >> 
