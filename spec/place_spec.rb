
require "spec_helper"

module Bioshogi
  describe Place do
    it "コレクション" do
      assert { Place.each.present? == true }
    end

    it "lookup" do
      assert { Place.lookup("68").name == "６八" }
      assert { Place.lookup(nil) == nil }
    end

    it "[]" do
      assert { Place["68"].name == "６八" }
      assert { Place[nil] == nil }
    end

    it "適当な文字列を内部座標に変換する" do
      assert { Place.fetch("４三").name == "４三" }
      assert { Place.fetch("四三").name == "４三" }
      assert { Place.fetch("43").name   == "４三" }
      assert { Place.fetch([0, 0]).name == "９一" }

      expect { Place.fetch("卍三")   }.to raise_error(SyntaxDefact)
      expect { Place.fetch(nil)      }.to raise_error(SyntaxDefact)
      expect { Place.fetch("")       }.to raise_error(SyntaxDefact)
      expect { Place.fetch("0")      }.to raise_error(SyntaxDefact)
      expect { Place.fetch([-1, 0])  }.to raise_error(SyntaxDefact)
      expect { Place.fetch([0, -1])  }.to raise_error(SyntaxDefact)

      expect { Dimension.wh_change([2, 2]) { Place.fetch("33")   } }.to raise_error(SyntaxDefact)
      expect { Dimension.wh_change([2, 2]) { Place.fetch("３三") } }.to raise_error(SyntaxDefact)
    end

    it "#name は、座標を表す" do
      assert { Place.fetch("４三").name    == "４三" }
    end

    it "to_s は name の alias" do
      assert { Place.fetch("４三").to_s == "４三" }
    end

    it "#hankaku_number は ７六歩(77) の 77 の部分を作るときに使う" do
      assert Place.fetch("４三").hankaku_number == "43"
    end

    it "相手陣地に入っているか？" do
      assert Place.fetch("１二").opp_side?(Location[:black]) == true
      assert Place.fetch("１三").opp_side?(Location[:black]) == true
      assert Place.fetch("１四").opp_side?(Location[:black]) == false
      assert Place.fetch("１六").opp_side?(Location[:white]) == false
      assert Place.fetch("１七").opp_side?(Location[:white]) == true
      assert Place.fetch("１八").opp_side?(Location[:white]) == true
    end

    it "ベクトルを加算して新しい座標オブジェクトを返す" do
      assert Place.fetch("５五").vector_add(V[1, 2]).name == "４七"
    end

    it "内部座標を返す" do
      assert { Place["１一"].to_xy == [8, 0] }
    end

    it "盤面内か？" do
      assert { Place["１一"].vector_add(V[0, 0]) }
      assert { !Place["１一"].vector_add(V[1, 0]) }
      assert { !Place["１一"].vector_add(V[0, -1]) }
    end

    it "内部状態" do
      Place["５五"].inspect
    end

    it "すべての座標を返す" do
      assert Place.collect(&:name) == ["９一", "８一", "７一", "６一", "５一", "４一", "３一", "２一", "１一", "９二", "８二", "７二", "６二", "５二", "４二", "３二", "２二", "１二", "９三", "８三", "７三", "６三", "５三", "４三", "３三", "２三", "１三", "９四", "８四", "７四", "６四", "５四", "４四", "３四", "２四", "１四", "９五", "８五", "７五", "６五", "５五", "４五", "３五", "２五", "１五", "９六", "８六", "７六", "６六", "５六", "４六", "３六", "２六", "１六", "９七", "８七", "７七", "６七", "５七", "４七", "３七", "２七", "１七", "９八", "８八", "７八", "６八", "５八", "４八", "３八", "２八", "１八", "９九", "８九", "７九", "６九", "５九", "４九", "３九", "２九", "１九"]
    end

    it "反転" do
      assert Place["７六"].flip == Place["３四"]
    end

    it "左右反転" do
      assert Place["７六"].flop == Place["３六"]
    end

    it "後手なら反転" do
      assert Place["７六"].white_then_flip(:white) == Place["３四"]
    end

    it "シリアライズからの復元" do
      place = Place["１一"]
      place = Marshal.load(Marshal.dump(place))
      assert place == Place["１一"]
    end

    it "ソートできる" do
      a = Place["１一"]
      b = Place["２一"]
      assert { [a, b].sort == [b, a] }
    end

    ################################################################################

    it "move_to_xy" do
      assert { Place["55"].move_to_xy(Location[:white], 1, -1).name == "６六" }
    end

    it "move_to" do
      assert { Place["55"].move_to(Location[:white], V.up)                  == Place["56"] }
      assert { Place["55"].move_to(Location[:white], :up)                   == Place["56"] }
      assert { Place["55"].move_to(Location[:white], :up, magnification: 0) == Place["55"] }
      assert { Place["55"].move_to(Location[:white], :up, magnification: 2) == Place["57"] }
      assert { Place["55"].move_to(Location[:white], :up, magnification: 9) == nil         }
    end

    it "move_to_*_edge" do
      assert { Place["55"].move_to_bottom_edge(Location[:white]) == Place["51"] }
      assert { Place["55"].move_to_top_edge(Location[:white])    == Place["59"] }
      assert { Place["55"].move_to_left_edge(Location[:white])   == Place["15"] }
      assert { Place["55"].move_to_right_edge(Location[:white])  == Place["95"] }
    end

    ################################################################################
  end
end
