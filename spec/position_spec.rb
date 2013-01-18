# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Position do
    it "座標パース" do
      Position::Hpos.parse("1").name.should == "1"
      Position::Hpos.parse("１").name.should == "1"
    end
    it "座標の幅" do
      Position::Hpos.value_range.to_s.should == "0..8"
    end
    context "valid" do
      it "正しい座標" do
        Position::Hpos.parse(0).valid?.should == true
      end
      it "間違った座標" do
        Position::Hpos.parse(-1).valid?.should == false
      end
    end
    it "座標反転" do
      Position::Hpos.parse("1").reverse.name.should == "9"
    end
    it "数字表記" do
      Position::Hpos.parse("1").number_format.should == "1"
    end
  end
end
