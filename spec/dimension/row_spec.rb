require "spec_helper"

RSpec.describe Bioshogi::Dimension::Row do
  it "数字表記" do
    assert { Bioshogi::Dimension::Row.fetch("一").hankaku_number == "1" }
  end

  it "全角数字表記" do
    assert { Bioshogi::Dimension::Row.fetch("９").hankaku_number == "9" }
  end

  it "インスタンスが異なっても同じ座標なら同じ" do
    assert { Bioshogi::Dimension::Row.fetch("1") == Bioshogi::Dimension::Row.fetch("一") }
  end

  it "ソート" do
    assert { [Bioshogi::Dimension::Column.fetch("1"), Bioshogi::Dimension::Column.fetch("2")].sort.collect(&:name) == ["２", "１"] }
  end

  it "上下の位置" do
    assert { Bioshogi::Dimension::Row.top.name    == "一" }
    assert { Bioshogi::Dimension::Row.bottom.name == "九" }
  end

  ################################################################################

  it "distance_from_middle" do
    assert { Bioshogi::Dimension::Row.fetch("4").distance_from_middle == 1 }
    assert { Bioshogi::Dimension::Row.fetch("5").distance_from_middle == 0 }
    assert { Bioshogi::Dimension::Row.fetch("6").distance_from_middle == 1 }
  end

  it "top_spaces" do
    assert { Bioshogi::Dimension::Row.fetch("1").top_spaces == 0 }
    assert { Bioshogi::Dimension::Row.fetch("5").top_spaces == 4 }
    assert { Bioshogi::Dimension::Row.fetch("9").top_spaces == 8 }
  end

  it "bottom_spaces" do
    assert { Bioshogi::Dimension::Row.fetch("1").bottom_spaces == 8 }
    assert { Bioshogi::Dimension::Row.fetch("5").bottom_spaces == 4 }
    assert { Bioshogi::Dimension::Row.fetch("9").bottom_spaces == 0 }
  end

  it "opp_side?" do
    assert { Bioshogi::Dimension::Row.fetch("3").opp_side? == true  }
    assert { Bioshogi::Dimension::Row.fetch("4").opp_side? == false }
  end

  it "not_opp_side?" do
    assert { Bioshogi::Dimension::Row.fetch("3").not_opp_side? == false }
    assert { Bioshogi::Dimension::Row.fetch("4").not_opp_side? == true  }
  end

  it "own_side?" do
    assert { Bioshogi::Dimension::Row.fetch("6").own_side? == false }
    assert { Bioshogi::Dimension::Row.fetch("7").own_side? == true  }
  end

  it "not_own_side?" do
    assert { Bioshogi::Dimension::Row.fetch("6").not_own_side? == true  }
    assert { Bioshogi::Dimension::Row.fetch("7").not_own_side? == false }
  end

  it "funoue_line_ni_uita?" do
    assert { Bioshogi::Dimension::Row.fetch("5").funoue_line_ni_uita? == false  }
    assert { Bioshogi::Dimension::Row.fetch("6").funoue_line_ni_uita? == true   }
    assert { Bioshogi::Dimension::Row.fetch("7").funoue_line_ni_uita? == false  }
  end

  it "kurai_sasae?" do
    assert { Bioshogi::Dimension::Row.fetch("5").kurai_sasae? == false }
    assert { Bioshogi::Dimension::Row.fetch("6").kurai_sasae? == true  }
  end

  it "just_nyuugyoku?" do
    assert { Bioshogi::Dimension::Row.fetch("2").just_nyuugyoku? == false }
    assert { Bioshogi::Dimension::Row.fetch("3").just_nyuugyoku? == true  }
    assert { Bioshogi::Dimension::Row.fetch("4").just_nyuugyoku? == false }
  end

  it "atoippo_nyuugyoku?" do
    assert { Bioshogi::Dimension::Row.fetch("3").atoippo_nyuugyoku? == false }
    assert { Bioshogi::Dimension::Row.fetch("4").atoippo_nyuugyoku? == true  }
    assert { Bioshogi::Dimension::Row.fetch("5").atoippo_nyuugyoku? == false }
  end

  it "tarefu_desuka?" do
    assert { Bioshogi::Dimension::Row.fetch("1").tarefu_desuka? == false }
    assert { Bioshogi::Dimension::Row.fetch("2").tarefu_desuka? == true  }
    assert { Bioshogi::Dimension::Row.fetch("3").tarefu_desuka? == true  }
    assert { Bioshogi::Dimension::Row.fetch("4").tarefu_desuka? == true  }
    assert { Bioshogi::Dimension::Row.fetch("5").tarefu_desuka? == false }
  end

  ################################################################################

  describe "5x5の盤面" do
    it "works" do
      Bioshogi::Dimension.change([5, 5]) do
        expect(Bioshogi::Container::Basic.player_test.board.to_s).to eq(<<~EOT)
          ５ ４ ３ ２ １
        +---------------+
        | ・ ・ ・ ・ ・|一
        | ・ ・ ・ ・ ・|二
        | ・ ・ ・ ・ ・|三
        | ・ ・ ・ ・ ・|四
        | ・ ・ ・ ・ ・|五
        +---------------+
          EOT
      end
    end
  end
end
