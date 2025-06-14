
require "spec_helper"

RSpec.describe Bioshogi::Place do
  it "コレクション" do
    assert { Bioshogi::Place.each.present? == true }
  end

  it "lookup" do
    assert { Bioshogi::Place.lookup("68").name == "６八" }
    assert { Bioshogi::Place.lookup(nil) == nil }
  end

  it "[]" do
    assert { Bioshogi::Place["68"].name == "６八" }
    assert { Bioshogi::Place[nil] == nil }
  end

  it "zero" do
    assert { Bioshogi::Place.zero }
  end

  it "適当な文字列を内部座標に変換する" do
    assert { Bioshogi::Place.fetch("４三").name == "４三" }
    assert { Bioshogi::Place.fetch("四三").name == "４三" }
    assert { Bioshogi::Place.fetch("43").name   == "４三" }
    assert { Bioshogi::Place.fetch([0, 0]).name == "９一" }

    expect { Bioshogi::Place.fetch("卍三")   }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Place.fetch(nil)      }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Place.fetch("")       }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Place.fetch("0")      }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Place.fetch([-1, 0])  }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Place.fetch([0, -1])  }.to raise_error(Bioshogi::SyntaxDefact)

    expect { Bioshogi::Dimension.change([2, 2]) { Bioshogi::Place.fetch("33")   } }.to raise_error(Bioshogi::SyntaxDefact)
    expect { Bioshogi::Dimension.change([2, 2]) { Bioshogi::Place.fetch("３三") } }.to raise_error(Bioshogi::SyntaxDefact)
  end

  it "#name は、座標を表す" do
    assert { Bioshogi::Place.fetch("４三").name    == "４三" }
  end

  it "to_s は name の alias" do
    assert { Bioshogi::Place.fetch("４三").to_s == "４三" }
  end

  it "#hankaku_number は ７六歩(77) の 77 の部分を作るときに使う" do
    assert Bioshogi::Place.fetch("４三").hankaku_number == "43"
  end

  it "相手陣地に入っているか？" do
    assert Bioshogi::Place.fetch("１二").opp_side?(Bioshogi::Location[:black]) == true
    assert Bioshogi::Place.fetch("１三").opp_side?(Bioshogi::Location[:black]) == true
    assert Bioshogi::Place.fetch("１四").opp_side?(Bioshogi::Location[:black]) == false
    assert Bioshogi::Place.fetch("１六").opp_side?(Bioshogi::Location[:white]) == false
    assert Bioshogi::Place.fetch("１七").opp_side?(Bioshogi::Location[:white]) == true
    assert Bioshogi::Place.fetch("１八").opp_side?(Bioshogi::Location[:white]) == true
  end

  it "ベクトルを加算して新しい座標オブジェクトを返す" do
    assert Bioshogi::Place.fetch("５五").vector_add(Bioshogi::V[1, 2]).name == "４七"
  end

  it "内部座標を返す" do
    assert { Bioshogi::Place["１一"].to_xy == [8, 0] }
  end

  it "盤面内か？" do
    assert { Bioshogi::Place["１一"].vector_add(Bioshogi::V[0, 0]) }
    assert { !Bioshogi::Place["１一"].vector_add(Bioshogi::V[1, 0]) }
    assert { !Bioshogi::Place["１一"].vector_add(Bioshogi::V[0, -1]) }
  end

  it "内部状態" do
    Bioshogi::Place["５五"].inspect
  end

  it "すべての座標を返す" do
    assert Bioshogi::Place.collect(&:name) == ["９一", "８一", "７一", "６一", "５一", "４一", "３一", "２一", "１一", "９二", "８二", "７二", "６二", "５二", "４二", "３二", "２二", "１二", "９三", "８三", "７三", "６三", "５三", "４三", "３三", "２三", "１三", "９四", "８四", "７四", "６四", "５四", "４四", "３四", "２四", "１四", "９五", "８五", "７五", "６五", "５五", "４五", "３五", "２五", "１五", "９六", "８六", "７六", "６六", "５六", "４六", "３六", "２六", "１六", "９七", "８七", "７七", "６七", "５七", "４七", "３七", "２七", "１七", "９八", "８八", "７八", "６八", "５八", "４八", "３八", "２八", "１八", "９九", "８九", "７九", "６九", "５九", "４九", "３九", "２九", "１九"]
  end

  it "反転" do
    assert Bioshogi::Place["７六"].flip == Bioshogi::Place["３四"]
  end

  it "左右反転" do
    assert Bioshogi::Place["７六"].flop == Bioshogi::Place["３六"]
  end

  it "後手なら反転" do
    assert Bioshogi::Place["７六"].white_then_flip(:white) == Bioshogi::Place["３四"]
  end

  it "シリアライズからの復元" do
    place = Bioshogi::Place["１一"]
    place = Marshal.load(Marshal.dump(place))
    assert place == Bioshogi::Place["１一"]
  end

  it "ソートできる" do
    a = Bioshogi::Place["１一"]
    b = Bioshogi::Place["２一"]
    assert { [a, b].sort == [b, a] }
  end

  ################################################################################ アクセサ

  it "column" do
    assert { Bioshogi::Place["34"].column.name == "３" }
  end

  it "row" do
    assert { Bioshogi::Place["34"].row.name == "四" }
  end

  ################################################################################

  it "2次元の距離" do
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["55"]) == 0 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["54"]) == 1 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["44"]) == 2 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["45"]) == 1 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["46"]) == 2 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["56"]) == 1 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["66"]) == 2 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["65"]) == 1 }
    assert { Bioshogi::Place["55"].distance(Bioshogi::Place["64"]) == 2 }
  end

  ################################################################################

  it "move_to_xy" do
    assert { Bioshogi::Place["55"].move_to_xy(Bioshogi::Location[:white], 1, -1).name == "６六" }
  end

  it "relative_move_to" do
    assert { Bioshogi::Place["55"].relative_move_to(Bioshogi::Location[:white], Bioshogi::V.up) == Bioshogi::Place["56"] }
    assert { Bioshogi::Place["55"].relative_move_to(Bioshogi::Location[:white], :up) == Bioshogi::Place["56"] }
    assert { Bioshogi::Place["55"].relative_move_to(Bioshogi::Location[:white], :up, magnification: 0) == Bioshogi::Place["55"] }
    assert { Bioshogi::Place["55"].relative_move_to(Bioshogi::Location[:white], :up, magnification: 2) == Bioshogi::Place["57"] }
    assert { Bioshogi::Place["55"].relative_move_to(Bioshogi::Location[:white], :up, magnification: 9) == nil }
  end

  it "move_to_*_edge" do
    assert { Bioshogi::Place["55"].move_to_bottom_edge(Bioshogi::Location[:white]) == Bioshogi::Place["51"] }
    assert { Bioshogi::Place["55"].move_to_top_edge(Bioshogi::Location[:white])    == Bioshogi::Place["59"] }
    assert { Bioshogi::Place["55"].move_to_left_edge(Bioshogi::Location[:white])   == Bioshogi::Place["15"] }
    assert { Bioshogi::Place["55"].move_to_right_edge(Bioshogi::Location[:white])  == Bioshogi::Place["95"] }
  end

  it "king_default_place?" do
    assert { !Bioshogi::Place["55"].king_default_place?(Bioshogi::Location[:black]) }
    assert { Bioshogi::Place["51"].king_default_place?(Bioshogi::Location[:white]) }
    assert { Bioshogi::Place["59"].king_default_place?(Bioshogi::Location[:black]) }
  end

  ################################################################################
end
# >> Bioshogi::Coverage report generated for Bioshogi::RSpec to /Bioshogi::Users/ikeda/src/bioshogi/coverage. 5 / 13 Bioshogi::LOC (38.46%) covered.
# >> ...F...F.......F..Bioshogi::FFFFFF
# >>
# >> Bioshogi::Failures:
# >>
# >>   1) Bioshogi::Place 適当な文字列を内部座標に変換する
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>        expected Bioshogi::SyntaxDefact, got #<Bioshogi::NoMethodError: undefined method `change' for Bioshogi::Dimension:Module> with backtrace:
# >>          # -:33:in `block (3 levels) in <# >>          # -:33:in `block (2 levels) in <# >>      # -:33:in `block (2 levels) in <# >>
# >>   2) Bioshogi::Place 相手陣地に入っているか？
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `opp_side?' for #<Bioshogi::Place １二>
# >>      # -:50:in `block (2 levels) in <# >>
# >>   3) Bioshogi::Place 後手なら反転
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `white_then_flip' for #<Bioshogi::Place ７六>
# >>      # -:89:in `block (2 levels) in <# >>
# >>   4) Bioshogi::Place column
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `column' for #<Bioshogi::Place ３四>
# >>      # -:107:in `block (3 levels) in <# >>      # -:107:in `block (2 levels) in <# >>
# >>   5) Bioshogi::Place row
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `row' for #<Bioshogi::Place ３四>
# >>      # -:111:in `block (3 levels) in <# >>      # -:111:in `block (2 levels) in <# >>
# >>   6) Bioshogi::Place move_to_xy
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `move_to_xy' for #<Bioshogi::Place ５五>
# >>      # -:117:in `block (3 levels) in <# >>      # -:117:in `block (2 levels) in <# >>
# >>   7) Bioshogi::Place relative_move_to
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `up' for Bioshogi::V:Class
# >>      # -:121:in `block (3 levels) in <# >>      # -:121:in `block (2 levels) in <# >>
# >>   8) Bioshogi::Place move_to_*_edge
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `move_to_bottom_edge' for #<Bioshogi::Place ５五>
# >>      # -:129:in `block (3 levels) in <# >>      # -:129:in `block (2 levels) in <# >>
# >>   9) Bioshogi::Place king_default_place?
# >>      Bioshogi::Failure/Bioshogi::Error: Bioshogi::Unable to find - to read failed line
# >>
# >>      Bioshogi::NoMethodError:
# >>        undefined method `king_default_place?' for #<Bioshogi::Place ５五>
# >>      # -:136:in `block (3 levels) in <# >>      # -:136:in `block (2 levels) in <# >>
# >> Bioshogi::Top 10 slowest examples (0.05245 seconds, 73.3% of total time):
# >>   Bioshogi::Place 適当な文字列を内部座標に変換する
# >>     0.01704 seconds -:20
# >>   Bioshogi::Place 盤面内か？
# >>     0.01355 seconds -:66
# >>   Bioshogi::Place コレクション
# >>     0.01309 seconds -:6
# >>   Bioshogi::Place lookup
# >>     0.00203 seconds -:10
# >>   Bioshogi::Place []
# >>     0.00178 seconds -:15
# >>   Bioshogi::Place #name は、座標を表す
# >>     0.00114 seconds -:37
# >>   Bioshogi::Place to_s は name の alias
# >>     0.00099 seconds -:41
# >>   Bioshogi::Place ソートできる
# >>     0.00098 seconds -:98
# >>   Bioshogi::Place 内部座標を返す
# >>     0.00094 seconds -:62
# >>   Bioshogi::Place column
# >>     0.00092 seconds -:106
# >>
# >> Bioshogi::Finished in 0.07157 seconds (files took 2.59 seconds to load)
# >> 24 examples, 9 failures
# >>
# >> Bioshogi::Failed examples:
# >>
# >> rspec -:20 # Bioshogi::Place 適当な文字列を内部座標に変換する
# >> rspec -:49 # Bioshogi::Place 相手陣地に入っているか？
# >> rspec -:88 # Bioshogi::Place 後手なら反転
# >> rspec -:106 # Bioshogi::Place column
# >> rspec -:110 # Bioshogi::Place row
# >> rspec -:116 # Bioshogi::Place move_to_xy
# >> rspec -:120 # Bioshogi::Place relative_move_to
# >> rspec -:128 # Bioshogi::Place move_to_*_edge
# >> rspec -:135 # Bioshogi::Place king_default_place?
# >>
