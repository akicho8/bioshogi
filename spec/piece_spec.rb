require_relative "spec_helper"

module Warabi
  describe Piece do
    it "コレクション" do
      Piece.each.present?.should == true
    end

    it "取得" do
      Piece[:pawn].class.should == Piece
      Piece[:pawn].key.should == :pawn
      Piece.lookup(:pawn).class.should == Piece
      Piece.lookup("歩").name.should == "歩"
      Piece.lookup("").should == nil
      Piece.lookup(nil).should == nil
    end

    it "fetchの場合、無効な名前だったら例外を出す" do
      expect { Piece.fetch("成龍") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成と") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成飛") }.to raise_error(PieceNotFound)
    end

    it "駒の情報" do
      piece = Piece.lookup("飛")
      piece.name.should           == "飛"
      piece.promoted_name.should  == "龍"
      piece.basic_names.should    == ["飛", "HI", "R"]
      piece.promoted_names.should == ["龍", "竜", "RY"]
      piece.names.should          == ["飛", "HI", "R", "龍", "竜", "RY"]
      piece.key.should            == :rook
      piece.promotable?.should    == true
      piece.select_vectors2(promoted: false, location: Location[:black]).should == Set[RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]]
      piece.select_vectors2(promoted: true, location: Location[:black]).should  == Set[OV[-1, -1], OV[1, -1], OV[-1, 1], OV[1, 1], RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]]
    end

    it "同じ種類の駒ならオブジェクトは同じだけどcloneすると変わる" do
      (Piece.lookup("歩") == Piece.lookup("歩")).should == true
      (Piece.lookup("歩").clone == Piece.lookup("歩")).should == false
    end

    it "sort" do
      [Piece[:pawn], Piece[:king]].sort.should == [Piece[:king], Piece[:pawn]]
    end

    # it "シリアライズ" do
    #   p Piece.lookup("歩")
    #   s = Marshal.load(Marshal.dump(Piece.instance))
    #   p s
    #   p Piece.lookup("歩")
    # end
  end
end

