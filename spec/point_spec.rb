# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Point do
    it ".parse は、適当な文字列を内部座標に変換する" do
      Point.parse("４三").name.should == "4三"
      Point.parse("43").name.should   == "4三"
      Point.parse([0, 0]).name.should == "9一"

      expect { Point.parse("四三") }.to raise_error(UnknownPositionName)
      expect { Point.parse(nil)    }.to raise_error(MustNotHappen)
      expect { Point.parse("")     }.to raise_error(PointSyntaxError)
      expect { Point.parse("0")    }.to raise_error(PointSyntaxError)
    end

    it ".[] は .parse の alias" do
      Point["４三"].name.should == "4三"
    end

    it "#valid?" do
      Point.parse("4三").valid?.should    == true
      Point.parse([-1, -1]).valid?.should == false
    end

    it "#name は、座標を表す" do
      Point.parse("4三").name.should    == "4三"
      Point.parse([-1, -1]).name.should == "盤外"
    end

    it "#to_s_digit は 7六歩(77) の 77 の部分を作るときに使う" do
      Point.parse("４三").to_s_digit.should == "43"
    end
  end
end
