require_relative "spec_helper"

module Bushido
  describe Piece do
    it "コレクション" do
      Piece.each.present?.should == true
    end

    it "取得" do
      Piece[:pawn].class.should == Piece
      Piece[:pawn].key.should == :pawn
      Piece.get(:pawn).class.should == Piece
      Piece.get("歩").name.should == "歩"
      Piece.get("").should == nil
      Piece.get(nil).should == nil
    end

    it "fetchの場合、無効な名前だったら例外を出す" do
      expect { Piece.fetch("成龍") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成と") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成飛") }.to raise_error(PieceNotFound)
    end

    it "駒の情報" do
      piece = Piece.get("飛")
      piece.name.should                 == "飛"
      piece.promoted_name.should        == "龍"
      piece.basic_names.should          == ["飛", "rook"]
      piece.promoted_names.should       == ["龍", "ROOK", "竜"]
      piece.names.should                == ["飛", "rook", "龍", "ROOK", "竜"]
      piece.key.should             == :rook
      piece.promotable?.should          == true
      piece.select_vectors.should       == Set[RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]]
      piece.select_vectors(true).should == Set[OV[-1, -1], OV[1, -1], OV[-1, 1], OV[1, 1], RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]]
    end

    it "同じ種類の駒ならオブジェクトは同じだけどcloneすると変わる" do
      (Piece.get("歩") == Piece.get("歩")).should == true
      (Piece.get("歩").clone == Piece.get("歩")).should == false
    end

    # it "シリアライズ" do
    #   p Piece.get("歩")
    #   s = Marshal.load(Marshal.dump(Piece.instance))
    #   p s
    #   p Piece.get("歩")
    # end
  end
end

