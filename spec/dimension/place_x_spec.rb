require "spec_helper"

module Bioshogi
  describe Dimension::PlaceX do
    describe "範囲外または無効" do
      it "引数が根本的にダメなのでエラー" do
        expect { Dimension::PlaceX.fetch("")  }.to raise_error(SyntaxDefact)
        expect { Dimension::PlaceX.fetch(nil) }.to raise_error(SyntaxDefact)
        expect { Dimension::PlaceX.fetch(-1)  }.to raise_error(SyntaxDefact)
      end
      it "横の範囲外" do
        expect { Dimension.wh_change([2, 2]) { Dimension::PlaceX.fetch("３") } }.to raise_error(SyntaxDefact)
      end
      it "縦の範囲外" do
        expect { Dimension.wh_change([2, 2]) { Dimension::PlaceY.fetch("三")  } }.to raise_error(SyntaxDefact)
      end
      # it "正しい座標" do
      #     assert { Dimension::PlaceX.fetch(0).valid? == true }
      #   end
      #   it "間違った座標" do
      #     assert { Dimension::PlaceX.fetch(-1).valid? == false }
      #   end
      # end
    end

    describe "座標パース" do
      describe "正常" do
        it "横" do
          assert { Dimension::PlaceX.fetch("1").name == "１" }
          assert { Dimension::PlaceX.fetch("１").name == "１" }
          assert { Dimension::PlaceX.fetch("一").name == "１" }
        end

        it "縦" do
          assert { Dimension::PlaceY.fetch("1").name == "一" }
          assert { Dimension::PlaceY.fetch("１").name == "一" }
          assert { Dimension::PlaceY.fetch("一").name == "一" }
        end
      end
    end

    it "座標の幅" do
      assert { Dimension::PlaceX.value_range.to_s == "0...9" }
    end

    it "座標反転" do
      assert Dimension::PlaceX.fetch("１").flip.name == "９"
    end

    it "左右の位置" do
      assert { Dimension::PlaceX.left.name  == "９" }
      assert { Dimension::PlaceX.right.name == "１" }
    end

    it "左右のスペース" do
      assert { Dimension::PlaceX.fetch("7").left_spaces(Location[:black])  == 2 }
      assert { Dimension::PlaceX.fetch("7").right_spaces(Location[:black]) == 6 }
      assert { Dimension::PlaceX.fetch("7").left_spaces(Location[:white])  == 6 }
      assert { Dimension::PlaceX.fetch("7").right_spaces(Location[:white]) == 2 }
    end

    it "x_is_two_to_eight?" do
      assert { Dimension::PlaceX.fetch("1").x_is_two_to_eight? == false }
      assert { Dimension::PlaceX.fetch("2").x_is_two_to_eight? == true  }
      assert { Dimension::PlaceX.fetch("5").x_is_two_to_eight? == true  }
      assert { Dimension::PlaceX.fetch("8").x_is_two_to_eight? == true  }
      assert { Dimension::PlaceX.fetch("9").x_is_two_to_eight? == false }
    end

    it "x_is_three_to_seven?" do
      assert { Dimension::PlaceX.fetch("2").x_is_three_to_seven? == false }
      assert { Dimension::PlaceX.fetch("3").x_is_three_to_seven? == true  }
      assert { Dimension::PlaceX.fetch("5").x_is_three_to_seven? == true  }
      assert { Dimension::PlaceX.fetch("7").x_is_three_to_seven? == true  }
      assert { Dimension::PlaceX.fetch("8").x_is_three_to_seven? == false }
    end

    it "x_is_two_or_eight?" do
      assert { Dimension::PlaceX.fetch("1").x_is_two_or_eight? == false }
      assert { Dimension::PlaceX.fetch("2").x_is_two_or_eight? == true  }
      assert { Dimension::PlaceX.fetch("5").x_is_two_or_eight? == false }
      assert { Dimension::PlaceX.fetch("8").x_is_two_or_eight? == true  }
      assert { Dimension::PlaceX.fetch("9").x_is_two_or_eight? == false }
    end
  end
end
