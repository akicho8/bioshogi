require "spec_helper"

module Bioshogi
  module Dimension
    describe DimensionRow do
      it "数字表記" do
        assert { DimensionRow.fetch("一").hankaku_number == "1" }
      end

      it "全角数字表記" do
        assert { DimensionRow.fetch("９").hankaku_number == "9" }
      end

      it "インスタンスが異なっても同じ座標なら同じ" do
        assert { DimensionRow.fetch("1") == DimensionRow.fetch("一") }
      end

      it "ソート" do
        assert { [DimensionColumn.fetch("1"), DimensionColumn.fetch("2")].sort.collect(&:name) == ["２", "１"] }
      end

      it "上下の位置" do
        assert { DimensionRow.top.name    == "一" }
        assert { DimensionRow.bottom.name == "九" }
      end

      ################################################################################

      it "top_spaces" do
        assert { DimensionRow.fetch("1").top_spaces == 0 }
        assert { DimensionRow.fetch("5").top_spaces == 4 }
        assert { DimensionRow.fetch("9").top_spaces == 8 }
      end

      it "bottom_spaces" do
        assert { DimensionRow.fetch("1").bottom_spaces == 8 }
        assert { DimensionRow.fetch("5").bottom_spaces == 4 }
        assert { DimensionRow.fetch("9").bottom_spaces == 0 }
      end

      it "opp_side?" do
        assert { DimensionRow.fetch("3").opp_side? == true  }
        assert { DimensionRow.fetch("4").opp_side? == false }
      end

      it "not_opp_side?" do
        assert { DimensionRow.fetch("3").not_opp_side? == false }
        assert { DimensionRow.fetch("4").not_opp_side? == true  }
      end

      it "own_side?" do
        assert { DimensionRow.fetch("6").own_side? == false }
        assert { DimensionRow.fetch("7").own_side? == true  }
      end

      it "not_own_side?" do
        assert { DimensionRow.fetch("6").not_own_side? == true  }
        assert { DimensionRow.fetch("7").not_own_side? == false }
      end

      it "kurai_sasae?" do
        assert { DimensionRow.fetch("5").kurai_sasae? == false }
        assert { DimensionRow.fetch("6").kurai_sasae? == true  }
      end

      it "sandanme?" do
        assert { DimensionRow.fetch("2").sandanme? == false }
        assert { DimensionRow.fetch("3").sandanme? == true  }
        assert { DimensionRow.fetch("4").sandanme? == false }
      end

      it "works" do
        assert { DimensionRow.fetch("3").yondanme? == false }
        assert { DimensionRow.fetch("4").yondanme? == true  }
        assert { DimensionRow.fetch("5").yondanme? == false }
      end

      ################################################################################

      describe "5x5の盤面" do
        it "works" do
          Dimension.wh_change([5, 5]) do
            expect(Container::Basic.player_test.board.to_s).to eq(<<~EOT)
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
  end
end
