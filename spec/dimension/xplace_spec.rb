require "spec_helper"

module Bioshogi
  describe Dimension do
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

    it "数字表記" do
      assert { Dimension::PlaceY.fetch("一").hankaku_number == "1" }
    end

    it "全角数字表記" do
      assert Dimension::PlaceY.fetch("９").hankaku_number == "9"
    end

    it "成れるか？" do
      assert Dimension::PlaceY.fetch("二").promotable?(Location[:black]) == true
      assert Dimension::PlaceY.fetch("三").promotable?(Location[:black]) == true
      assert Dimension::PlaceY.fetch("四").promotable?(Location[:black]) == false
      assert Dimension::PlaceY.fetch("六").promotable?(Location[:white]) == false
      assert Dimension::PlaceY.fetch("七").promotable?(Location[:white]) == true
      assert Dimension::PlaceY.fetch("八").promotable?(Location[:white]) == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      assert Dimension::PlaceY.fetch("1") == Dimension::PlaceY.fetch("一")
    end

    it "ソート" do
      assert [Dimension::PlaceX.fetch("1"), Dimension::PlaceX.fetch("2")].sort.collect(&:name) == ["２", "１"]
    end

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
