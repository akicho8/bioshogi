require "spec_helper"

module Bioshogi
  describe Player do
    it "works" do
      xcontainer = Xcontainer.new
      xcontainer.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { xcontainer.current_player.mate_advantage? == true  }
      assert { xcontainer.opponent_player.mate_advantage? == true }
      assert { xcontainer.position_invalid? == true               }
    end

    it "works" do
      xcontainer = Xcontainer.new
      xcontainer.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { xcontainer.current_player.mate_danger? == true     }
      assert { xcontainer.current_player.mate_advantage? == false }
      assert { xcontainer.position_invalid? == false              }
    end
  end
end
