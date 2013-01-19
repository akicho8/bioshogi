# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Position do
    context "座標パース" do
      it "エラー" do
        expect { Position::Hpos.parse("")  }.to raise_error(PositionSyntaxError)
        expect { Position::Hpos.parse(nil) }.to raise_error(PositionSyntaxError)
      end
      it "横" do
        Position::Hpos.parse("1").name.should == "1"
        Position::Hpos.parse("１").name.should == "1"
      end
      it "縦" do
        Position::Vpos.parse("一").name.should == "一"
        Position::Vpos.parse("1").name.should == "一"
      end
    end
    it "座標の幅" do
      Position::Hpos.value_range.to_s.should == "0..8"
    end
    context "バリデーション" do
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
      Position::Vpos.parse("一").number_format.should == "1"
    end
    it "インスタンスが異なっても同じ座標なら同じ" do
      Position::Vpos.parse("1").should == Position::Vpos.parse("一")
    end
  end
end
