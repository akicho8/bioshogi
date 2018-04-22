require_relative "spec_helper"

module Warabi
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
        mediator.current_player.move_hands.collect(&:to_s).should                            == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]
        mediator.current_player.move_hands(promoted_preferred: true).collect(&:to_s).should  == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２一角成(12)"]
        mediator.current_player.move_hands(promoted_preferred: false).collect(&:to_s).should == ["△２二玉(11)", "△２一玉(11)", "△２三角成(12)", "△２三角(12)", "△２一角成(12)", "△２一角(12)"]
        mediator.current_player.move_hands(king_captured_only: true).collect(&:to_s).should  == ["△２三角成(12)"]
        mediator.current_player.legal_all_hands.collect(&:to_s).should                      == ["△２一玉(11)"]
        mediator.current_player.oute_kakerareteru?.should                                    == false
        mediator.current_player.suguni_ou_toreru?.should                                     == true
      end
    end
  end
end
