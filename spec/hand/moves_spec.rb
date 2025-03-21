require "spec_helper"

describe Bioshogi::Player do
  it "works" do
    Bioshogi::Dimension.change([2, 3]) do
      container = Bioshogi::Container::Basic.new
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
      assert { container.current_player.move_hands.collect(&:to_s)                                                == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２三角(12)", "△２一角成(12)", "△２一角(12)"] }
      assert { container.current_player.move_hands(promoted_only: true, king_captured_only: true).collect(&:to_s) == ["△２三角成(12)"]                                                                                   }
      assert { container.current_player.legal_all_hands.collect(&:to_s)                                           == ["△２一玉(11)"]                                                                                     }
      assert { container.current_player.mate_danger?                                                              == false                                                                                                }
      assert { container.current_player.mate_advantage?                                                           == true                                                                                                 }
      assert { container.current_player.king_capture_move_hands.collect(&:to_s)                                   == ["△２三角成(12)"]                                                                                   }
    end
  end
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> .
# >>
# >> Bioshogi::Top 1 slowest examples (0.02146 seconds, 49.0% of total time):
# >>   Bioshogi::Player works
# >>     0.02146 seconds -:5
# >>
# >> Bioshogi::Finished in 0.04384 seconds (files took 2.68 seconds to load)
# >> 1 example, 0 failures
# >>
