require_relative "spec_helper"

module Bioshogi
  describe PieceBox do
    it do
      piece_box = PieceBox.new(Piece.s_to_h("飛玉角角"))
      assert { piece_box.to_sfen(:black) == "RK2B" }
      assert { piece_box.to_csa(:black) == "P+00OU00HI00KA00KA" }
      assert { piece_box.to_s(separator: "/") == "玉/飛/角二" }
      assert { piece_box.score == 45880 }
    end

    it do
      a = PieceBox.new(Piece.s_to_h("飛玉"))
      b = PieceBox.new(Piece.s_to_h("玉飛"))
      assert { (a == b) == true }
    end
  end
end
