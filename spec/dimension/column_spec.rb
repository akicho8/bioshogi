require "spec_helper"

RSpec.describe Bioshogi::Dimension::Column do
  describe "範囲外または無効" do
    it "引数が根本的にダメなのでエラー" do
      expect { Bioshogi::Dimension::Column.fetch("")  }.to raise_error(Bioshogi::SyntaxDefact)
      expect { Bioshogi::Dimension::Column.fetch(nil) }.to raise_error(Bioshogi::SyntaxDefact)
      expect { Bioshogi::Dimension::Column.fetch(-1)  }.to raise_error(Bioshogi::SyntaxDefact)
    end
    it "横の範囲外" do
      expect { Bioshogi::Dimension.change([2, 2]) { Bioshogi::Dimension::Column.fetch("３") } }.to raise_error(Bioshogi::SyntaxDefact)
    end
    it "縦の範囲外" do
      expect { Bioshogi::Dimension.change([2, 2]) { Bioshogi::Dimension::Row.fetch("三")  } }.to raise_error(Bioshogi::SyntaxDefact)
    end
    # it "正しい座標" do
    #     assert { Bioshogi::Dimension::Column.fetch(0).valid? == true }
    #   end
    #   it "間違った座標" do
    #     assert { Bioshogi::Dimension::Column.fetch(-1).valid? == false }
    #   end
    # end
  end

  describe "座標パース" do
    describe "正常" do
      it "横" do
        assert { Bioshogi::Dimension::Column.fetch("1").name == "１" }
        assert { Bioshogi::Dimension::Column.fetch("１").name == "１" }
        assert { Bioshogi::Dimension::Column.fetch("一").name == "１" }
      end

      it "縦" do
        assert { Bioshogi::Dimension::Row.fetch("1").name == "一" }
        assert { Bioshogi::Dimension::Row.fetch("１").name == "一" }
        assert { Bioshogi::Dimension::Row.fetch("一").name == "一" }
      end
    end
  end

  it "座標の幅" do
    assert { Bioshogi::Dimension::Column.value_range.to_s == "0...9" }
  end

  it "座標反転" do
    assert Bioshogi::Dimension::Column.fetch("１").flip.name == "９"
  end

  it "左右の位置" do
    assert { Bioshogi::Dimension::Column.left.name  == "９" }
    assert { Bioshogi::Dimension::Column.right.name == "１" }
  end

  # it "座標サイズを変更したときも反転が正しい" do
  #   assert { Bioshogi::Dimension::Column.fetch("2").flip.to_human_int == 8 }
  #   Bioshogi::Dimension.change([5, 9]) do
  #     assert { Bioshogi::Dimension::Column.fetch("2").flip.to_human_int == 4 }
  #   end
  #   assert { Bioshogi::Dimension::Column.fetch("2").flip.to_human_int == 8 }
  # end

  ################################################################################

  it "left_spaces" do
    assert { Bioshogi::Dimension::Column.fetch("1").left_spaces == 8 }
    assert { Bioshogi::Dimension::Column.fetch("5").left_spaces == 4 }
    assert { Bioshogi::Dimension::Column.fetch("9").left_spaces == 0 }
  end

  it "right_spaces" do
    assert { Bioshogi::Dimension::Column.fetch("1").right_spaces == 0 }
    assert { Bioshogi::Dimension::Column.fetch("5").right_spaces == 4 }
    assert { Bioshogi::Dimension::Column.fetch("9").right_spaces == 8 }
  end

  it "column_spaces_min" do
    assert { Bioshogi::Dimension::Column.fetch("4").column_spaces_min == 3 }
    assert { Bioshogi::Dimension::Column.fetch("5").column_spaces_min == 4 }
    assert { Bioshogi::Dimension::Column.fetch("6").column_spaces_min == 3 }
  end

  it "left_or_right_to_closer_side" do
    assert { Bioshogi::Dimension::Column.fetch("4").left_or_right_to_closer_side == :right }
    assert { Bioshogi::Dimension::Column.fetch("5").left_or_right_to_closer_side == :left  }
    assert { Bioshogi::Dimension::Column.fetch("6").left_or_right_to_closer_side == :left  }
  end

  it "column_is_second_to_eighth?" do
    assert { Bioshogi::Dimension::Column.fetch("1").column_is_second_to_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("2").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("3").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("7").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("8").column_is_second_to_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("9").column_is_second_to_eighth? == false }
  end

  it "column_is_second_or_eighth?" do
    assert { Bioshogi::Dimension::Column.fetch("1").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("2").column_is_second_or_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("3").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("7").column_is_second_or_eighth? == false }
    assert { Bioshogi::Dimension::Column.fetch("8").column_is_second_or_eighth? == true  }
    assert { Bioshogi::Dimension::Column.fetch("9").column_is_second_or_eighth? == false }
  end

  it "column_is_three_to_seven?" do
    assert { Bioshogi::Dimension::Column.fetch("1").column_is_three_to_seven? == false }
    assert { Bioshogi::Dimension::Column.fetch("2").column_is_three_to_seven? == false }
    assert { Bioshogi::Dimension::Column.fetch("3").column_is_three_to_seven? == true  }
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_three_to_seven? == true  }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_three_to_seven? == true  }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_three_to_seven? == true  }
    assert { Bioshogi::Dimension::Column.fetch("7").column_is_three_to_seven? == true  }
    assert { Bioshogi::Dimension::Column.fetch("8").column_is_three_to_seven? == false }
    assert { Bioshogi::Dimension::Column.fetch("9").column_is_three_to_seven? == false }
  end

  it "column_is_center?" do
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_center? == false }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_center? == true  }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_center? == false }
  end

  it "column_is_edge?" do
    assert { Bioshogi::Dimension::Column.fetch("1").column_is_edge? == true  }
    assert { Bioshogi::Dimension::Column.fetch("2").column_is_edge? == false }
    assert { Bioshogi::Dimension::Column.fetch("8").column_is_edge? == false }
    assert { Bioshogi::Dimension::Column.fetch("9").column_is_edge? == true  }
  end

  it "column_is_right_side?" do
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_right_side? == true  }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_right_side? == false }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_right_side? == false }
  end

  it "column_is_left_side?" do
    assert { Bioshogi::Dimension::Column.fetch("4").column_is_left_side? == false }
    assert { Bioshogi::Dimension::Column.fetch("5").column_is_left_side? == false }
    assert { Bioshogi::Dimension::Column.fetch("6").column_is_left_side? == true  }
  end

  it "column_is_right_edge?" do
    assert { Bioshogi::Dimension::Column.fetch("1").column_is_right_edge? == true  }
    assert { Bioshogi::Dimension::Column.fetch("2").column_is_right_edge? == false }
  end

  it "column_is_left_edge?" do
    assert { Bioshogi::Dimension::Column.fetch("8").column_is_left_edge? == false }
    assert { Bioshogi::Dimension::Column.fetch("9").column_is_left_edge? == true  }
  end
end
