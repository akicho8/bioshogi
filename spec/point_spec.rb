require_relative "spec_helper"

module Warabi
  describe Point do
    it "コレクション" do
      Point.each.present?.should == true
    end

    it "lookup" do
      Point.lookup("68").name.should == "６八"
      Point.lookup(nil).should == nil
    end

    it "[]" do
      Point["68"].name.should == "６八"
      Point[nil].should == nil
    end

    it "適当な文字列を内部座標に変換する" do
      Point.fetch("４三").name.should == "４三"
      Point.fetch("四三").name.should == "４三"
      Point.fetch("43").name.should   == "４三"
      Point.fetch([0, 0]).name.should == "９一"

      expect { Point.fetch("卍三") }.to raise_error(SyntaxDefact)
      expect { Point.fetch(nil)    }.to raise_error(SyntaxDefact)
      expect { Point.fetch("")     }.to raise_error(SyntaxDefact)
      expect { Point.fetch("0")    }.to raise_error(SyntaxDefact)

      expect { Board.size_change([2, 2]) { Point.fetch("33")   } }.to raise_error(SyntaxDefact)
      expect { Board.size_change([2, 2]) { Point.fetch("３三") } }.to raise_error(SyntaxDefact)
    end

    it "#valid?" do
      Point.fetch("４三").valid?.should    == true
      Point.fetch([-1, -1]).valid?.should == false
    end

    it "#name は、座標を表す" do
      Point.fetch("４三").name.should    == "４三"
      Point.fetch([-1, -1]).name.should == "盤外"
    end

    it "to_s は name の alias" do
      Point.fetch("４三").to_s.should == "４三"
    end

    it "#number_format は ７六歩(77) の 77 の部分を作るときに使う" do
      Point.fetch("４三").number_format.should == "43"
    end

    it "相手陣地に入っているか？" do
      Point.fetch("１二").promotable?(Location[:black]).should == true
      Point.fetch("１三").promotable?(Location[:black]).should == true
      Point.fetch("１四").promotable?(Location[:black]).should == false
      Point.fetch("１六").promotable?(Location[:white]).should == false
      Point.fetch("１七").promotable?(Location[:white]).should == true
      Point.fetch("１八").promotable?(Location[:white]).should == true
    end

    it "ベクトルを加算して新しい座標オブジェクトを返す" do
      Point.fetch("５五").vector_add([1, 2]).name.should == "４七"
    end

    it "内部座標を返す" do
      Point["１一"].to_xy.should == [8, 0]
    end

    it "盤面内か？" do
      Point["１一"].vector_add([0, 0]).valid?.should  == true
      Point["１一"].vector_add([1, 0]).valid?.should  == false
      Point["１一"].vector_add([0, -1]).valid?.should == false
    end

    it "内部状態" do
      Point["５五"].inspect
    end

    it "すべての座標を返す" do
      Point.collect(&:name).should == ["９一", "８一", "７一", "６一", "５一", "４一", "３一", "２一", "１一", "９二", "８二", "７二", "６二", "５二", "４二", "３二", "２二", "１二", "９三", "８三", "７三", "６三", "５三", "４三", "３三", "２三", "１三", "９四", "８四", "７四", "６四", "５四", "４四", "３四", "２四", "１四", "９五", "８五", "７五", "６五", "５五", "４五", "３五", "２五", "１五", "９六", "８六", "７六", "６六", "５六", "４六", "３六", "２六", "１六", "９七", "８七", "７七", "６七", "５七", "４七", "３七", "２七", "１七", "９八", "８八", "７八", "６八", "５八", "４八", "３八", "２八", "１八", "９九", "８九", "７九", "６九", "５九", "４九", "３九", "２九", "１九"]
    end

    it "反転" do
      Point["７六"].reverse.should == Point["３四"]
    end

    it "後手なら反転" do
      Point["７六"].reverse_if_white(:white).should == Point["３四"]
    end

    it "シリアライズからの復元" do
      point = Point["１一"]
      point = Marshal.load(Marshal.dump(point))
      point.should == Point["１一"]
    end

    it "ソートできる" do
      a = Point["１一"]
      b = Point["２一"]
      [a, b].sort.should == [b, a]
    end
  end
end
