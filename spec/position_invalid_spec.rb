require "spec_helper"

module Bioshogi
  describe Player do
    it do
      mediator = Mediator.new
      mediator.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { mediator.current_player.mate_advantage? == true  }
      assert { mediator.opponent_player.mate_advantage? == true }
      assert { mediator.position_invalid? == true               }
    end

    it do
      mediator = Mediator.new
      mediator.placement_from_bod(<<~EOT)
後手の持駒：
+---+
|v玉|
|v歩|
| 玉|
+---+
  先手の持駒：
手数＝0
EOT
      assert { mediator.current_player.mate_danger? == true     }
      assert { mediator.current_player.mate_advantage? == false }
      assert { mediator.position_invalid? == false              }
    end
  end
end
