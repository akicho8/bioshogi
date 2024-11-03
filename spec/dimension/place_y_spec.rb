require "spec_helper"

module Bioshogi
  describe Dimension::PlaceY do
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
