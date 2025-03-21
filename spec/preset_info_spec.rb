require "spec_helper"

describe Bioshogi::PresetInfo do
  describe "日本語ゆえの表記ゆれ問題" do
    it "飛車落ち" do
      assert { Bioshogi::PresetInfo["飛車落ち"] }
      assert { Bioshogi::PresetInfo["飛落ち"]   }
      assert { Bioshogi::PresetInfo["飛落"]     }
    end

    it "5五将棋" do
      assert { Bioshogi::PresetInfo["55将棋"]   }
      assert { Bioshogi::PresetInfo["５５将棋"] }
      assert { Bioshogi::PresetInfo["5五将棋"]  }
      assert { Bioshogi::PresetInfo["五五将棋"] }
      assert { Bioshogi::PresetInfo["五々将棋"] }
    end
  end

  it "詰将棋は平手にしておけば問題ない" do
    assert { Bioshogi::PresetInfo["詰将棋"] == Bioshogi::PresetInfo["平手"] }
  end

  it "to_short_sfen" do
    assert { Bioshogi::PresetInfo["平手"].to_short_sfen   == "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1" }
    assert { Bioshogi::PresetInfo["香落ち"].to_short_sfen == "position sfen lnsgkgsn1/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1" }
  end

  it "black_only_soldiers" do
    assert Bioshogi::PresetInfo["平手"].location_split[:black].collect(&:name) == ["▲９七歩", "▲９九香", "▲８七歩", "▲８八角", "▲８九桂", "▲７七歩", "▲７九銀", "▲６七歩", "▲６九金", "▲５七歩", "▲５九玉", "▲４七歩", "▲４九金", "▲３七歩", "▲３九銀", "▲２七歩", "▲２八飛", "▲２九桂", "▲１七歩", "▲１九香"]
  end

  it "ある" do
    assert Bioshogi::PresetInfo["飛香落ち"]
  end

  it "「香落ち」だと判断できる" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_shape(<<~EOT)
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    |v香v桂v銀v金v玉v金v銀v桂 ・|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
    +---------------------------+
      EOT
    assert { container.board.preset_info.key == :"香落ち" }
  end

  it "▲は平手状態だけど△は不明" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_shape(<<~EOT)
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    |v香v桂v銀v金v玉v金v銀 ・ ・|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | 香 桂 銀 金 玉 金 銀 桂 香|九
    +---------------------------+
      EOT
    assert { container.board.preset_info == nil }
  end

  it "▲は「香落ち」だけど後手は平手状態ではないので正式な手合い名は出せない" do
    container = Bioshogi::Container::Basic.new
    container.board.placement_from_shape(<<~EOT)
      ９ ８ ７ ６ ５ ４ ３ ２ １
    +---------------------------+
    |v香v桂v銀v金v玉v金v銀v桂 ・|一
    | ・v飛 ・ ・ ・ ・ ・v角 ・|二
    |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
    | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
    | 歩 歩 歩 歩 歩 歩 歩 歩 歩|七
    | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
    | ・ 桂 銀 金 玉 金 銀 桂 香|九
    +---------------------------+
      EOT
    assert { container.board.preset_info == nil }
  end

  it "to_board" do
    assert { Bioshogi::PresetInfo["飛香落ち"].to_board }
  end

  it "to_turn_info" do
    assert { Bioshogi::PresetInfo["平手"].to_turn_info.current_location.key   == :black }
    assert { Bioshogi::PresetInfo["香落ち"].to_turn_info.current_location.key == :white }
  end

  it "declined_soldiers" do
    assert { Bioshogi::PresetInfo["二枚落ち"].declined_soldiers.collect(&:to_s) == ["△８二飛", "△２二角"] }
  end

  it "handicap_shift" do
    assert { Bioshogi::PresetInfo["平手"].handicap_shift   == 0 }
    assert { Bioshogi::PresetInfo["角落ち"].handicap_shift == 1 }
  end
end
