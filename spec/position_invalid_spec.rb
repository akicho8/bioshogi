require_relative "spec_helper"

module Warabi
  describe Player do
    it do
      mediator = Mediator.new
      mediator.placement_from_bod <<~EOT
      後手の持駒：
      +---+
        |v玉|
      | 玉|
      +---+
        先手の持駒：
      手数＝0
      EOT
      mediator.current_player.suguni_ou_toreru?.should == true
      mediator.opponent_player.suguni_ou_toreru?.should == true
      mediator.position_invalid?.should == true
    end

    it do
      mediator = Mediator.new
      mediator.placement_from_bod <<~EOT
      後手の持駒：
      +---+
        |v玉|
      |v歩|
      | 玉|
      +---+
        先手の持駒：
      手数＝0
      EOT
      mediator.current_player.oute_kakerareteru?.should == true
      mediator.current_player.suguni_ou_toreru?.should == false
      mediator.position_invalid?.should == false
    end
  end
end
