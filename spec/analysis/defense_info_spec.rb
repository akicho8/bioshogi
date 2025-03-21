require "spec_helper"

describe Bioshogi::Analysis::DefenseInfo do
  xdescribe "keyとnameは異なる" do
    it "key" do
      assert { Bioshogi::Analysis::DefenseInfo["ビッグ4(振)"].key == :"ビッグ4(振)" }
    end
    it "name" do
      assert { Bioshogi::Analysis::DefenseInfo["ビッグ4(振)"].name == "ビッグ4" }
    end
  end

  it "ある" do
    assert { Bioshogi::Analysis::DefenseInfo["アヒル囲い"] }
  end

  it "同じ" do
    assert Bioshogi::Analysis::DefenseInfo["アヒル囲い"] == Bioshogi::Analysis::DefenseInfo["金開き"]
  end

  it "tactic_info" do
    assert { Bioshogi::Analysis::DefenseInfo.first.tactic_info.key == :defense }
  end

  describe "木構造" do
    it "先祖" do
      assert { Bioshogi::Analysis::DefenseInfo["ダイヤモンド美濃"].ancestors.collect(&:name) == ["美濃囲い", "片美濃囲い"] }
    end

    it "親" do
      assert { Bioshogi::Analysis::DefenseInfo["美濃囲い"].parent.name == "片美濃囲い" }
    end

    it "子供" do
      assert { Bioshogi::Analysis::DefenseInfo["片美濃囲い"].children.collect(&:name) == ["美濃囲い", "片銀冠", "銀美濃", "木村美濃", "大山美濃", "美濃熊囲い"] }
    end

    it "子孫" do
      assert { Bioshogi::Analysis::DefenseInfo["片美濃囲い"].descendants.collect(&:name) == ["美濃囲い", "高美濃囲い", "振り飛車四枚美濃", "ダイヤモンド美濃", "片銀冠", "銀冠", "銀美濃", "木村美濃", "裾固め", "大山美濃", "美濃熊囲い"] }
    end
  end

  it "anaguma_elems" do
    assert { Bioshogi::Analysis::DefenseInfo.anaguma_elems.size > 1 }
  end
end
