# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Piece do
    describe ".create" do
      subject { Piece.create(:pawn) }
      it { should be_an_instance_of Piece::Pawn }
    end

    describe ".get" do
      it { Piece.get("歩").class.should == Piece::Pawn }
      it { Piece.get("").should == nil }
      it { Piece.get(nil).should == nil }
    end

    it "駒の名前" do
      Piece.get("角").name.should == "角"
      Piece.get("馬").name.should == "角"

      Piece.names.should == ["歩", "pawn", "と", "PAWN", "角", "bishop", "馬", "BISHOP", "飛", "rook", "龍", "ROOK", "香", "lance", "成香", "LANCE", "桂", "knight", "成桂", "KNIGHT", "銀", "silver", "成銀", "SILVER", "金", "gold", "GOLD", "玉", "king", "KING"]
    end

    it "無効な名前シリーズ" do
      expect { Piece.get!("成龍") }.to raise_error(PieceNotFound)
      expect { Piece.get!("成と") }.to raise_error(PieceNotFound)
      expect { Piece.get!("成飛") }.to raise_error(PieceNotFound)
    end
  end

  # ここのテストが微妙
  module Piece
    describe Pawn do
      its(:name) { should be_an_instance_of String }
      its(:basic_vectors1) { should be_an_instance_of Array }
      its(:promotable?) { should be_true }
    end

    describe Gold do
      its(:promotable?) { should be_false }
    end

    describe King do
      its(:promotable?) { should be_false }
    end

    describe "すべての駒" do
      subject { [Pawn, Bishop, Rook, Lance, Knight, Silver, Gold, King].collect{|klass|klass.new.name}.join }
      it { should == "歩角飛香桂銀金玉" }
    end
  end
end
