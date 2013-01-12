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

    it "#number_format は 7六歩(77) の 77 の部分を作るときに使う" do
      Point.parse("４三").number_format.should == "43"
    end

    it "相手陣地に入っているか？" do
      Point.parse("１二").promotable?(:black).should == true
      Point.parse("１三").promotable?(:black).should == true
      Point.parse("１四").promotable?(:black).should == false
      Point.parse("１六").promotable?(:white).should == false
      Point.parse("１七").promotable?(:white).should == true
      Point.parse("１八").promotable?(:white).should == true
    end

    it "ベクトルを加算して新しい座標オブジェクトを返す" do
      Point.parse("５五").add_vector([1, 2]).name.should == "4七"
    end

    it "内部座標を返す" do
      Point["１一"].to_xy.should == [8, 0]
    end

    it "自分自身を返す" do
      (object = Point["１一"]).to_point.object_id.should == object.object_id
    end

    it "盤面内か？" do
      Point["１一"].add_vector([0, 0]).valid?.should  == true
      Point["１一"].add_vector([1, 0]).valid?.should  == false
      Point["１一"].add_vector([0, -1]).valid?.should == false
    end

    it "内部状態" do
      Point["５五"].inspect
    end
  end
end
