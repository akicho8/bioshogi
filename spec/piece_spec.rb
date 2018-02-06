require_relative "spec_helper"

module Warabi
  describe Piece do
    before do
      @pieces = [Piece["歩"], Piece["歩"], Piece["飛"]]
    end

    it "class_methods" do
      Piece.s_to_h("飛0 角 竜1 馬2 龍2").should == {:rook=>3, :bishop=>3}
      Piece.h_to_a(rook: 3, "角" => 3, "飛" => 1).collect(&:name).should == ["飛", "飛", "飛", "角", "角", "角", "飛"]
      Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name).should == ["飛", "飛", "飛", "飛", "角", "角", "角"]
      Piece.a_to_s(["竜", :pawn, "竜"], ordered: true, separator: "/").should == "飛二/歩"
      Piece.s_to_a2("▲歩2 飛 △歩二飛 ▲金").transform_values { |e| e.collect(&:name) }.should == {:black=>["歩", "歩", "飛", "金"], :white=>["歩", "歩", "飛"]}
    end

    it "s_to_a" do
      Piece.s_to_a("歩2 飛").should           == @pieces
      Piece.s_to_a("歩歩 龍").should          == @pieces
      Piece.s_to_a("歩2 竜1").should          == @pieces
      Piece.s_to_a("歩2 飛 角0").should       == @pieces
      Piece.s_to_a("歩二 飛").should          == @pieces
      Piece.s_to_a("歩二飛角〇").should       == @pieces
      Piece.s_to_a("　歩二　\n　飛　").should == @pieces
      Piece.s_to_a(" 歩二 飛 ").should        == @pieces
      Piece.s_to_a(" 歩 二飛 ").should        == @pieces
    end

    it "a_to_s" do
      Piece.a_to_s(@pieces).should                == "歩二 飛"
      Piece.a_to_s(@pieces, ordered: true).should == "飛 歩二"
      Piece.a_to_s(@pieces, separator: "").should == "歩二飛"
    end

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
      piece.basic_names.should    == ["飛", "HI", "R", :rook]
      piece.promoted_names.should == ["龍", "竜", "RY"]
      piece.names.should          == ["飛", "HI", "R", :rook, "龍", "竜", "RY"]
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
