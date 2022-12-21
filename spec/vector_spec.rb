require "spec_helper"

module Bioshogi
  describe PieceVector do
    it "works" do
      assert { PieceVector[1, 2].flip_sign == PieceVector[-1, -2] }
    end
  end
end
