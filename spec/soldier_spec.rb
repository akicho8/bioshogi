require_relative "spec_helper"

module Bushido
  describe Soldier do
    it ".from_str" do
      Soldier.from_str("５一玉").to_s.should == "５一玉"
    end

    it "#to_s" do
      Soldier[point: Point["５一"], piece: Piece["玉"], promoted: false].to_s.should == "５一玉"
    end

    it "Point の #eql?, hash の定義で [1] - [1] = [] ができるようになる" do
      a = Soldier[point: Point["５一"], piece: Piece["玉"], promoted: false, location: Location[:white]]
      b = Soldier[point: Point["５一"], piece: Piece["玉"], promoted: false, location: Location[:white]]
      ([a] - [b]).should == []
    end
  end

  describe BattlerMove do
    it "#to_hand" do
      BattlerMove[point: Point["１三"], piece: Piece["銀"], origin_battler: Soldier.from_str("１四銀"), promoted_trigger: true].to_hand.should == "１三銀成(14)"
    end
  end

  describe PieceStake do
    it "#to_hand" do
      PieceStake[point: Point["１三"], piece: Piece["銀"]].to_hand.should == "１三銀打"
    end
  end
end
