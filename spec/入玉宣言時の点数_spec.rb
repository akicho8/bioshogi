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
|v歩 ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v飛vとvと ・v玉 ・ ・ ・ ・|
+---------------------------+
先手の持駒：歩歩
EOT
      assert { container.players.collect(&:ek_score) == [8, 13] }
    end
  end
end
# >> Coverage report generated for RSpec to /Users/ikeda/src/bioshogi/coverage. 5 / 13 LOC (38.46%) covered.
# >> .
# >> 
# >> Top 1 slowest examples (0.01398 seconds, 84.2% of total time):
# >>   入玉宣言時の点数 works
# >>     0.01398 seconds -:5
# >> 
# >> Finished in 0.01659 seconds (files took 0.63288 seconds to load)
# >> 1 example, 0 failures
# >> 
