require "spec_helper"

module Bioshogi
  describe Dimension do
    describe "座標パース" do
      it "引数が根本的にダメなのでエラー" do
        expect { Dimension::Xplace.fetch("")  }.to raise_error(SyntaxDefact)
        expect { Dimension::Xplace.fetch(nil) }.to raise_error(SyntaxDefact)
      end
      it "横の範囲外" do
        expect { Board.dimensiton_change([2, 2]) { Dimension::Xplace.fetch("３") } }.to raise_error(SyntaxDefact)
      end
      it "縦の範囲外" do
        expect { Board.dimensiton_change([2, 2]) { Dimension::Yplace.fetch("三")  } }.to raise_error(SyntaxDefact)
      end

      describe "正常" do
        it "横" do
          assert { Dimension::Xplace.fetch("1").name == "１" }
          assert { Dimension::Xplace.fetch("１").name == "１" }
          assert { Dimension::Xplace.fetch("一").name == "１" }
        end

        it "縦" do
          assert { Dimension::Yplace.fetch("1").name == "一" }
          assert { Dimension::Yplace.fetch("１").name == "一" }
          assert { Dimension::Yplace.fetch("一").name == "一" }
        end
      end
    end

    it "座標の幅" do
      assert { Dimension::Xplace.value_range.to_s == "0...9" }
    end

    describe "バリデーション" do
      it "正しい座標" do
        assert { Dimension::Xplace.fetch(0).valid? == true }
      end
      it "間違った座標" do
        assert { Dimension::Xplace.fetch(-1).valid? == false }
      end
    end

    it "座標反転" do
      assert Dimension::Xplace.fetch("１").flip.name == "９"
    end

    it "数字表記" do
      assert { Dimension::Yplace.fetch("一").hankaku_number == "1" }
    end

    it "全角数字表記" do
      assert Dimension::Yplace.fetch("９").hankaku_number == "9"
    end

    it "成れるか？" do
      assert Dimension::Yplace.fetch("二").promotable?(LocationInfo[:black]) == true
      assert Dimension::Yplace.fetch("三").promotable?(LocationInfo[:black]) == true
      assert Dimension::Yplace.fetch("四").promotable?(LocationInfo[:black]) == false
      assert Dimension::Yplace.fetch("六").promotable?(LocationInfo[:white]) == false
      assert Dimension::Yplace.fetch("七").promotable?(LocationInfo[:white]) == true
      assert Dimension::Yplace.fetch("八").promotable?(LocationInfo[:white]) == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      assert Dimension::Yplace.fetch("1") == Dimension::Yplace.fetch("一")
    end

    it "ソート" do
      assert [Dimension::Xplace.fetch("1"), Dimension::Xplace.fetch("2")].sort.collect(&:name) == ["２", "１"]
    end

    describe "5x5の盤面" do
      it "works" do
        Board.dimensiton_change([5, 5]) do
          expect(Mediator.player_test.board.to_s).to eq(<<~EOT)
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
