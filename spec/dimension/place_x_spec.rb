require "spec_helper"

module Bioshogi
  module Dimension
    describe PlaceX do
      describe "範囲外または無効" do
        it "引数が根本的にダメなのでエラー" do
          expect { PlaceX.fetch("")  }.to raise_error(SyntaxDefact)
          expect { PlaceX.fetch(nil) }.to raise_error(SyntaxDefact)
          expect { PlaceX.fetch(-1)  }.to raise_error(SyntaxDefact)
        end
        it "横の範囲外" do
          expect { Dimension.wh_change([2, 2]) { PlaceX.fetch("３") } }.to raise_error(SyntaxDefact)
        end
        it "縦の範囲外" do
          expect { Dimension.wh_change([2, 2]) { PlaceY.fetch("三")  } }.to raise_error(SyntaxDefact)
        end
        # it "正しい座標" do
        #     assert { PlaceX.fetch(0).valid? == true }
        #   end
        #   it "間違った座標" do
        #     assert { PlaceX.fetch(-1).valid? == false }
        #   end
        # end
      end

      describe "座標パース" do
        describe "正常" do
          it "横" do
            assert { PlaceX.fetch("1").name == "１" }
            assert { PlaceX.fetch("１").name == "１" }
            assert { PlaceX.fetch("一").name == "１" }
          end

          it "縦" do
            assert { PlaceY.fetch("1").name == "一" }
            assert { PlaceY.fetch("１").name == "一" }
            assert { PlaceY.fetch("一").name == "一" }
          end
        end
      end

      it "座標の幅" do
        assert { PlaceX.value_range.to_s == "0...9" }
      end

      it "座標反転" do
        assert PlaceX.fetch("１").flip.name == "９"
      end

      it "左右の位置" do
        assert { PlaceX.left.name  == "９" }
        assert { PlaceX.right.name == "１" }
      end

      ################################################################################

      it "left_spaces" do
        assert { PlaceX.fetch("1").left_spaces == 8 }
        assert { PlaceX.fetch("5").left_spaces == 4 }
        assert { PlaceX.fetch("9").left_spaces == 0 }
      end

      it "right_spaces" do
        assert { PlaceX.fetch("1").right_spaces == 0 }
        assert { PlaceX.fetch("5").right_spaces == 4 }
        assert { PlaceX.fetch("9").right_spaces == 8 }
      end

      it "x_is_two_to_eight?" do
        assert { PlaceX.fetch("1").x_is_two_to_eight? == false }
        assert { PlaceX.fetch("2").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("3").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("4").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("5").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("6").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("7").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("8").x_is_two_to_eight? == true  }
        assert { PlaceX.fetch("9").x_is_two_to_eight? == false }
      end

      it "x_is_two_or_eight?" do
        assert { PlaceX.fetch("1").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("2").x_is_two_or_eight? == true  }
        assert { PlaceX.fetch("3").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("4").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("5").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("6").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("7").x_is_two_or_eight? == false }
        assert { PlaceX.fetch("8").x_is_two_or_eight? == true  }
        assert { PlaceX.fetch("9").x_is_two_or_eight? == false }
      end

      it "x_is_three_to_seven?" do
        assert { PlaceX.fetch("1").x_is_three_to_seven? == false }
        assert { PlaceX.fetch("2").x_is_three_to_seven? == false }
        assert { PlaceX.fetch("3").x_is_three_to_seven? == true  }
        assert { PlaceX.fetch("4").x_is_three_to_seven? == true  }
        assert { PlaceX.fetch("5").x_is_three_to_seven? == true  }
        assert { PlaceX.fetch("6").x_is_three_to_seven? == true  }
        assert { PlaceX.fetch("7").x_is_three_to_seven? == true  }
        assert { PlaceX.fetch("8").x_is_three_to_seven? == false }
        assert { PlaceX.fetch("9").x_is_three_to_seven? == false }
      end

      it "x_is_center?" do
        assert { PlaceX.fetch("4").x_is_center? == false }
        assert { PlaceX.fetch("5").x_is_center? == true  }
        assert { PlaceX.fetch("6").x_is_center? == false }
      end

      it "x_is_edge?" do
        assert { PlaceX.fetch("1").x_is_edge? == true  }
        assert { PlaceX.fetch("2").x_is_edge? == false }
        assert { PlaceX.fetch("8").x_is_edge? == false }
        assert { PlaceX.fetch("9").x_is_edge? == true  }
      end

      it "x_is_right_area?" do
        assert { PlaceX.fetch("4").x_is_right_area? == true  }
        assert { PlaceX.fetch("5").x_is_right_area? == false }
        assert { PlaceX.fetch("6").x_is_right_area? == false }
      end

      it "x_is_left_area?" do
        assert { PlaceX.fetch("4").x_is_left_area? == false }
        assert { PlaceX.fetch("5").x_is_left_area? == false }
        assert { PlaceX.fetch("6").x_is_left_area? == true  }
      end

      it "x_is_right_edge?" do
        assert { PlaceX.fetch("1").x_is_right_edge? == true  }
        assert { PlaceX.fetch("2").x_is_right_edge? == false }
      end

      it "x_is_left_edge?" do
        assert { PlaceX.fetch("8").x_is_left_edge? == false }
        assert { PlaceX.fetch("9").x_is_left_edge? == true  }
      end
    end
  end
end
