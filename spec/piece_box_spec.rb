require_relative "spec_helper"

module Warabi
  describe PieceBox do
    it do
      piece_box = PieceBox.new(Piece.s_to_h("飛玉角角"))
      piece_box.to_sfen(:black).should == "RK2B"
      piece_box.to_csa(:black).should == "P+00OU00HI00KA00KA"
      piece_box.to_s(separator: "/").should == "玉/飛/角二"
      piece_box.score.should == 15879
    end

    it do
      a = PieceBox.new(Piece.s_to_h("飛玉"))
      b = PieceBox.new(Piece.s_to_h("玉飛"))
      (a == b).should == true
    end
  end
end
