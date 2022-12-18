require "spec_helper"

module Bioshogi
  describe Player do
    it "works" do
      Board.dimensiton_change([2, 3]) do
        container = Container.create
        container.placement_from_bod <<~EOT
        後手の持駒：
        +------+
        | ・v玉|
        | ・v角|
        | 玉 香|
        +------+
        先手の持駒：
        手数＝1
        EOT
        assert { container.current_player.move_hands(promoted_only: true).collect(&:to_s)                           == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]                                 }
        assert { container.current_player.move_hands(promoted_only: true).collect(&:to_s)                           == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]                                 }
        assert { container.current_player.move_hands.collect(&:to_s)                          == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２三角(12)", "△２一角成(12)", "△２一角(12)"] }
        assert { container.current_player.move_hands(promoted_only: true, king_captured_only: true).collect(&:to_s) == ["△２三角成(12)"]                                                                                   }
        assert { container.current_player.legal_all_hands.collect(&:to_s)                                           == ["△２一玉(11)"]                                                                                     }
        assert { container.current_player.mate_danger?                                                              == false                                                                                                }
        assert { container.current_player.mate_advantage?                                                           == true                                                                                                 }
        assert { container.current_player.king_capture_move_hands.collect(&:to_s)                                   == ["△２三角成(12)"]                                                                                   }
      end
    end
  end
end
