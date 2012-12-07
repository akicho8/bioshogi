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
  end

  # ここのテストが微妙
  module Piece
    describe Pawn do
      its(:name) { should be_an_instance_of String }
      its(:basic_vectors1) { should be_an_instance_of Array }
      its(:transformable?) { should be_true }
    end

    describe Gold do
      its(:transformable?) { should be_false }
    end

    describe King do
      its(:transformable?) { should be_false }
    end

    describe "すべての駒" do
      subject { [Pawn, Bishop, Rook, Lance, Knight, Silver, Gold, King].collect{|klass|klass.new.name}.join }
      it { should == "歩角飛香桂銀金玉" }
    end
  end
end
