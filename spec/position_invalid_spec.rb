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
      mediator.current_player.mate_advantage?.should == true
      mediator.opponent_player.mate_advantage?.should == true
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
      mediator.current_player.mate_danger?.should == true
      mediator.current_player.mate_advantage?.should == false
      mediator.position_invalid?.should == false
    end
  end
end
