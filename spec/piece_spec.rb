# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Piece do
    describe ".create" do
      subject { Piece.create(:fu) }
      it { should be_an_instance_of Piece::Fu }
    end

    describe ".get" do
      it { Piece.get("歩").class.should == Piece::Fu }
    end
  end

  module Piece
    describe Fu do
      its(:name) { should be_an_instance_of String }
      its(:basic_movable_cells) { should be_an_instance_of Array }
      its(:cleave?) { should be_false }
      its(:transformable?) { should be_true }
    end

    describe Ki do
      its(:transformable?) { should be_false }
    end

    describe Ou do
      its(:transformable?) { should be_false }
    end

    describe "すべての駒" do
      subject { [Fu, Ka, Hi, Ky, Ke, Gi, Ki, Ou].collect{|klass|klass.new.name}.join }
      it { should == "歩角飛香桂銀金王" }
    end
  end
end
