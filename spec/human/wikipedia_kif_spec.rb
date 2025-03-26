require "spec_helper"

RSpec.describe "ウィキペディアにある表記通りの解釈ができる" do
  def test1(str)
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_shape(<<~EOT)
    +---------------------------+
    | ・ ・ ・ ・ ・ と ・ ・ ・|
    | ・ 銀 ・ ・ と と ・ 龍 ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ 龍|
    | 銀 銀 ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|
    | 桂 ・ 桂 ・ ・ ・ ・ ・ ・|
    +---------------------------+
      EOT
    container.current_player.pieces_add("歩金銀桂")
    container.execute(str)
    container.hand_logs.last.to_kif_ki2_csa
  end

  describe "打" do
    it "７三に動ける盤上の駒があるので打を明示する" do
      assert { test1("７三銀打") == ["７三銀打", "７三銀打", "+0073GI"] }
      assert { test1("７三銀合") == ["７三銀打", "７三銀打", "+0073GI"] } # 入力では「打」の代わりに「合」と書いてもよい
    end
    it "７二に動ける盤上の銀がないので打を省略する" do
      assert { test1("７二銀")   == ["７二銀打", "７二銀", "+0072GI"] }
      assert { test1("７二銀打") == ["７二銀打", "７二銀", "+0072GI"] } # 入力では明示的に「打」を書いてもよい
    end
  end

  it "桂" do
    expect { test1("８七桂") }.to raise_error(Bioshogi::AmbiguousFormatError)
    assert { test1("８七桂右") == ["８七桂(79)", "８七桂右", "+7987KE"] }
    assert { test1("８七桂左") == ["８七桂(99)", "８七桂左", "+9987KE"] }
  end

  it "龍" do
    expect { test1("２四龍引") }.to raise_error(Bioshogi::AmbiguousFormatError)
    assert { test1("２四龍右") == ["２四龍(13)", "２四龍右", "+1324RY"] }
    assert { test1("２四龍左") == ["２四龍(22)", "２四龍左", "+2224RY"] }
  end

  it "と" do
    expect { test1("５一と右") }.to raise_error(Bioshogi::AmbiguousFormatError)
    expect { test1("５一と上") }.to raise_error(Bioshogi::AmbiguousFormatError)
    assert { test1("５一と右上") == ["５一と(42)", "５一と右上", "+4251TO"] }
  end

  it "銀" do
    assert { test1("９三銀右上成") == ["９三銀成(84)", "９三銀右上成", "+8493NG"] }
  end
end
