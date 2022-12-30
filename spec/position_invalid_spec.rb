require "spec_helper"

module Bioshogi
  describe Player do
    it "works" do
      container = Container::Basic.new
      container.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { container.current_player.mate_advantage? == true  }
      assert { container.opponent_player.mate_advantage? == true }
      assert { container.position_invalid? == true               }
    end

    it "works" do
      container = Container::Basic.new
      container.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { container.current_player.mate_danger? == true     }
      assert { container.current_player.mate_advantage? == false }
      assert { container.position_invalid? == false              }
    end
  end
end
