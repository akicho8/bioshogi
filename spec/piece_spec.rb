# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Piece do
    it "コレクション" do
      Piece.each.present?.must_equal true
    end

    it "取得" do
      Piece[:pawn].class.must_equal Piece::Pawn
      Piece.get(:pawn).class.must_equal Piece::Pawn
      Piece.get("歩").class.must_equal Piece::Pawn
      Piece.get("").must_equal nil
      Piece.get(nil).must_equal nil
    end

    it "get!の場合、無効な名前だったら例外を出す" do
      proc { Piece.get!("成龍") }.must_raise PieceNotFound
      proc { Piece.get!("成と") }.must_raise PieceNotFound
      proc { Piece.get!("成飛") }.must_raise PieceNotFound
    end

    it "駒の情報" do
      piece = Piece.get("飛")
      piece.name.must_equal "飛"
      piece.promoted_name.must_equal "龍"
      piece.basic_names.must_equal ["飛", "rook"]
      piece.promoted_names.must_equal ["龍", "ROOK", "竜"]
      piece.names.must_equal ["飛", "rook", "龍", "ROOK", "竜"]
      piece.sym_name.must_equal :rook
      piece.promotable?.must_equal true
      piece.basic_step_vectors.must_equal []
      piece.basic_series_vectors.must_equal [nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil]
      piece.promoted_step_vectors.must_equal [[-1, -1], [0, -1], [1, -1], [-1, 0], nil, [1, 0], [-1, 1], [0, 1], [1, 1]]
      piece.promoted_series_vectors.must_equal [nil, [0, -1], nil, [-1, 0], [1, 0], nil, [0, 1], nil]
    end

    it "同じ種類の駒ならオブジェクトは同じだけどcloneすると変わる" do
      (Piece.get("歩") == Piece.get("歩")).must_equal true
      (Piece.get("歩").clone == Piece.get("歩")).must_equal false
    end

    # it "シリアライズ" do
    #   p Piece.get("歩")
    #   s = Marshal.load(Marshal.dump(Piece.instance))
    #   p s
    #   p Piece.get("歩")
    # end
  end
end

