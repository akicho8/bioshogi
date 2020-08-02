require_relative "spec_helper"

module Bioshogi
  describe Player do
    it do
      Board.dimensiton_change([2, 3]) do
        mediator = Mediator.new
        mediator.placement_from_bod <<~EOT
        後手の持駒：
        +------+
        | ・v玉|
        | ・v角|
        | 玉 香|
        +------+
        先手の持駒：
        手数＝1
        EOT
        assert { mediator.current_player.move_hands(promoted_only: true).collect(&:to_s)                           == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]                                 }
        assert { mediator.current_player.move_hands(promoted_only: true).collect(&:to_s)                           == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]                                 }
        assert { mediator.current_player.move_hands.collect(&:to_s)                          == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２三角(12)", "△２一角成(12)", "△２一角(12)"] }
        assert { mediator.current_player.move_hands(promoted_only: true, king_captured_only: true).collect(&:to_s) == ["△２三角成(12)"]                                                                                   }
        assert { mediator.current_player.legal_all_hands.collect(&:to_s)                                           == ["△２一玉(11)"]                                                                                     }
        assert { mediator.current_player.mate_danger?                                                              == false                                                                                                }
        assert { mediator.current_player.mate_advantage?                                                           == true                                                                                                 }
        assert { mediator.current_player.king_capture_move_hands.collect(&:to_s)                                   == ["△２三角成(12)"]                                                                                   }
      end
    end
  end
end
