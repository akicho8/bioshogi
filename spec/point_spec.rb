# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Point do
    describe ".parse は、適当な文字列を内部座標に変換する" do
      it { Point.parse("４三").name.should == "4三" }
      it { Point.parse("43").name.should   == "4三" }
      it { Point.parse([0, 0]).name.should == "9一" }

      it { proc{Point.parse("四三")}.should raise_error(UnknownPositionName) }
      it { proc{Point.parse(nil)}.should    raise_error(MustNotHappen) }
      it { proc{Point.parse("")}.should     raise_error(PointSyntaxError) }
      it { proc{Point.parse("0")}.should    raise_error(PointSyntaxError) }
    end

    describe ".[] は .parse の alias" do
      it { Point["４三"].name.should == "4三" }
    end

    describe "#valid?" do
      it { Point.parse("4三").valid?.should    == true }
      it { Point.parse([-1, -1]).valid?.should == false }
    end

    describe "#name は、座標を表す" do
      it { Point.parse("4三").name.should    == "4三"  }
      it { Point.parse([-1, -1]).name.should == "盤外" }
    end

    describe "#to_s_digit は 7六歩(77) の 77 の部分を作るときに使う" do
      it { Point.parse("４三").to_s_digit.should == "43"  }
    end
  end
end
