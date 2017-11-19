require_relative "spec_helper"

module Bushido
  describe MiniSoldier do
    it ".from_str" do
      MiniSoldier.from_str("５一玉").to_s.should == "５一玉"
    end

    it "#to_s" do
      MiniSoldier[point: Point["５一"], piece: Piece["玉"], promoted: false].to_s.should == "５一玉"
    end
  end

  describe SoldierMove do
    it "#to_hand" do
      SoldierMove[point: Point["１三"], piece: Piece["銀"], origin_soldier: MiniSoldier.from_str("１四銀"), promoted_trigger: true].to_hand.should == "１三銀成(14)"
    end
  end

  describe PieceStake do
    it "#to_hand" do
      PieceStake[point: Point["１三"], piece: Piece["銀"]].to_hand.should == "１三銀打"
    end
  end
end
