# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Point do
    it "コレクション" do
      Point.each.present?.must_equal true
    end

    it ".parse は、適当な文字列を内部座標に変換する" do
      Point.parse("４三").name.must_equal "4三"
      Point.parse("43").name.must_equal "4三"
      Point.parse([0, 0]).name.must_equal "9一"

      proc { Point.parse("四三") }.must_raise PositionSyntaxError
      proc { Point.parse(nil)    }.must_raise MustNotHappen
      proc { Point.parse("")     }.must_raise PointSyntaxError
      proc { Point.parse("0")    }.must_raise PointSyntaxError
    end

    it ".[] は .parse の alias" do
      Point["４三"].name.must_equal "4三"
    end

    it "#valid?" do
      Point.parse("4三").valid?.must_equal true
      Point.parse([-1, -1]).valid?.must_equal false
    end

    it "#name は、座標を表す" do
      Point.parse("4三").name.must_equal "4三"
      Point.parse([-1, -1]).name.must_equal "盤外"
    end

    it "to_s は name の alias" do
      Point.parse("4三").to_s.must_equal "4三"
    end

    it "#number_format は 7六歩(77) の 77 の部分を作るときに使う" do
      Point.parse("４三").number_format.must_equal "43"
    end

    it "相手陣地に入っているか？" do
      Point.parse("１二").promotable?(Location[:black]).must_equal true
      Point.parse("１三").promotable?(Location[:black]).must_equal true
      Point.parse("１四").promotable?(Location[:black]).must_equal false
      Point.parse("１六").promotable?(Location[:white]).must_equal false
      Point.parse("１七").promotable?(Location[:white]).must_equal true
      Point.parse("１八").promotable?(Location[:white]).must_equal true
    end

    it "ベクトルを加算して新しい座標オブジェクトを返す" do
      Point.parse("５五").add_vector([1, 2]).name.must_equal "4七"
    end

    it "内部座標を返す" do
      Point["１一"].to_xy.must_equal [8, 0]
    end

    it "自分自身を返す" do
      (object = Point["１一"]).to_point.object_id.must_equal object.object_id
    end

    it "盤面内か？" do
      Point["１一"].add_vector([0, 0]).valid?.must_equal true
      Point["１一"].add_vector([1, 0]).valid?.must_equal false
      Point["１一"].add_vector([0, -1]).valid?.must_equal false
    end

    it "内部状態" do
      Point["５五"].inspect
    end

    it "すべての座標を返す" do
      Point.collect(&:name).must_equal ["9一", "8一", "7一", "6一", "5一", "4一", "3一", "2一", "1一", "9二", "8二", "7二", "6二", "5二", "4二", "3二", "2二", "1二", "9三", "8三", "7三", "6三", "5三", "4三", "3三", "2三", "1三", "9四", "8四", "7四", "6四", "5四", "4四", "3四", "2四", "1四", "9五", "8五", "7五", "6五", "5五", "4五", "3五", "2五", "1五", "9六", "8六", "7六", "6六", "5六", "4六", "3六", "2六", "1六", "9七", "8七", "7七", "6七", "5七", "4七", "3七", "2七", "1七", "9八", "8八", "7八", "6八", "5八", "4八", "3八", "2八", "1八", "9九", "8九", "7九", "6九", "5九", "4九", "3九", "2九", "1九"]
    end

    it "反転" do
      Point["７六"].reverse.must_equal Point["３四"]
    end

    it "後手なら反転" do
      Point["７六"].as_location(:white).must_equal Point["３四"]
    end

    it "シリアライズからの復元" do
      point = Point["１一"]
      point = Marshal.load(Marshal.dump(point))
      point.must_equal Point["１一"]
    end
  end
end
