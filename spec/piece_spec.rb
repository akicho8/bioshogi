require "spec_helper"

module Bioshogi
  describe Piece do
    before do
      @pieces = [Piece["歩"], Piece["歩"], Piece["飛"]]
    end

    it "class_methods" do
      assert { Piece.s_to_h("飛0 角 竜1 馬2 龍2") == {:rook=>3, :bishop=>3} }
      assert { Piece.h_to_a(rook: 3, "角" => 3, "飛" => 1).collect(&:name) == ["飛", "飛", "飛", "角", "角", "角", "飛"] }
      assert { Piece.s_to_a("飛0 角 竜1 馬2 龍2 飛").collect(&:name) == ["飛", "飛", "飛", "飛", "角", "角", "角"] }
      assert { Piece.a_to_s(["竜", :pawn, "竜"], ordered: true, separator: "/") == "飛二/歩" }
      assert { Piece.s_to_h2("▲歩2 飛 △歩二飛 ▲金") == {:black=>{:pawn=>2, :rook=>1, :gold=>1}, :white=>{:pawn=>2, :rook=>1}} }
    end

    it "漢数字" do
      assert { Piece.s_to_h("歩")       == { :pawn => 1  } }
      assert { Piece.s_to_h("歩〇")     == { :pawn => 0  } }
      assert { Piece.s_to_h("歩一")     == { :pawn => 1  } }
      assert { Piece.s_to_h("歩十〇")   == { :pawn => 10 } }
      assert { Piece.s_to_h("歩十")     == { :pawn => 10 } }
      assert { Piece.s_to_h("歩十一")   == { :pawn => 11 } }
      assert { Piece.s_to_h("歩二十一") == { :pawn => 21 } }
    end

    it "s_to_a" do
      assert { Piece.s_to_a("歩2 飛")           == @pieces }
      assert { Piece.s_to_a("歩歩 龍")          == @pieces }
      assert { Piece.s_to_a("歩2 竜1")          == @pieces }
      assert { Piece.s_to_a("歩2 飛 角0")       == @pieces }
      assert { Piece.s_to_a("歩二 飛")          == @pieces }
      assert { Piece.s_to_a("歩二飛角〇")       == @pieces }
      assert { Piece.s_to_a("　歩二　\n　飛　") == @pieces }
      assert { Piece.s_to_a(" 歩二 飛 ")        == @pieces }
      assert { Piece.s_to_a(" 歩 二飛 ")        == @pieces }
    end

    it "a_to_s" do
      assert { Piece.a_to_s(@pieces, ordered: false) == "歩二 飛" }
      assert { Piece.a_to_s(@pieces, ordered: true) == "飛 歩二" }
      assert { Piece.a_to_s(@pieces, separator: "/") == "飛/歩二" }
    end

    it "コレクション" do
      assert { Piece.each.present? == true }
    end

    it "取得" do
      assert { Piece[:pawn].class == Piece }
      assert { Piece[:pawn].key == :pawn }
      assert { Piece.lookup(:pawn).class == Piece }
      assert { Piece.lookup("歩").name == "歩" }
      assert { Piece.lookup("") == nil }
      assert { Piece.lookup(nil) == nil }
    end

    it "fetchの場合、無効な名前だったら例外を出す" do
      expect { Piece.fetch("成龍") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成と") }.to raise_error(PieceNotFound)
      expect { Piece.fetch("成飛") }.to raise_error(PieceNotFound)
    end

    it "駒の情報" do
      piece = Piece.lookup("飛")
      assert { piece.name           == "飛" }
      assert { piece.promoted_name  == "龍" }
      assert { piece.basic_names    == ["飛", "HI", "R", :rook] }
      assert { piece.promoted_names == ["龍", "竜", "RY"] }
      assert { piece.names          == ["飛", "HI", "R", :rook, "龍", "竜", "RY"] }
      assert { piece.key            == :rook }
      assert { piece.promotable?    == true }
    end

    it "all_vectors" do
      piece = Piece.lookup("飛")
      assert { piece.all_vectors(promoted: false, location: Location[:black]) == [RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]] }
      assert { piece.all_vectors(promoted: true,  location: Location[:black]) == [OV[-1, -1], OV[1, -1], OV[-1, 1], OV[1, 1], RV[0, -1], RV[-1, 0], RV[1, 0], RV[0, 1]] }
      assert { piece.all_vectors(promoted: false, location: Location[:white]) == [RV[0, 1], RV[1, 0], RV[-1, 0], RV[0, -1]] }
      assert { piece.all_vectors(promoted: true,  location: Location[:white]) == [OV[1, 1], OV[-1, 1], OV[1, -1], OV[-1, -1], RV[0, 1], RV[1, 0], RV[-1, 0], RV[0, -1]] }
    end

    it "KIFやKI2用にオプションで「杏」ではなく「成香」と表記する" do
      piece = Piece.lookup("香")
      assert { piece.any_name(true) == "杏" }
      assert { piece.any_name(true, char_type: :formal_sheet) == "成香" }
    end

    it "昔の表記に対応" do
      assert { Piece.lookup("仝").name == "香" }
      assert { Piece.lookup("今").name == "桂" }
    end

    it "同じ種類の駒はcloneしても一致する" do
      assert Piece.lookup("歩") == Piece.lookup("歩")
      assert Piece.lookup("歩").clone == Piece.lookup("歩")
    end

    it "sort" do
      assert { [Piece[:pawn], Piece[:king]].sort == [Piece[:king], Piece[:pawn]] }
    end
  end
end
