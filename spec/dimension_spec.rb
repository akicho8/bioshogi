require_relative "spec_helper"

module Warabi
  describe Dimension do
    describe "座標パース" do
      it "引数が根本的にダメなのでエラー" do
        expect { Dimension::Yplace.fetch("")  }.to raise_error(SyntaxDefact)
        expect { Dimension::Yplace.fetch(nil) }.to raise_error(SyntaxDefact)
      end
      it "横の範囲外" do
        expect { Board.dimensiton_change([2, 2]) { Dimension::Yplace.fetch("３") } }.to raise_error(SyntaxDefact)
      end
      it "縦の範囲外" do
        expect { Board.dimensiton_change([2, 2]) { Dimension::Xplace.fetch("三")  } }.to raise_error(SyntaxDefact)
      end

      describe "正常" do
        it "横" do
          assert { Dimension::Yplace.fetch("1").name == "１" }
          assert { Dimension::Yplace.fetch("１").name == "１" }
          assert { Dimension::Yplace.fetch("一").name == "１" }
        end

        it "縦" do
          assert { Dimension::Xplace.fetch("1").name == "一" }
          assert { Dimension::Xplace.fetch("１").name == "一" }
          assert { Dimension::Xplace.fetch("一").name == "一" }
        end
      end
    end

    it "座標の幅" do
      assert { Dimension::Yplace.value_range.to_s == "0...9" }
    end

    describe "バリデーション" do
      it "正しい座標" do
        assert { Dimension::Yplace.fetch(0).valid? == true }
      end
      it "間違った座標" do
        assert { Dimension::Yplace.fetch(-1).valid? == false }
      end
    end

    it "座標反転" do
      assert Dimension::Yplace.fetch("１").flip.name == "９"
    end

    it "数字表記" do
      assert { Dimension::Xplace.fetch("一").number_format == "1" }
    end

    it "全角数字表記" do
      assert Dimension::Xplace.fetch("９").number_format == "9"
    end

    it "成れるか？" do
      assert Dimension::Xplace.fetch("二").promotable?(Location[:black]) == true
      assert Dimension::Xplace.fetch("三").promotable?(Location[:black]) == true
      assert Dimension::Xplace.fetch("四").promotable?(Location[:black]) == false
      assert Dimension::Xplace.fetch("六").promotable?(Location[:white]) == false
      assert Dimension::Xplace.fetch("七").promotable?(Location[:white]) == true
      assert Dimension::Xplace.fetch("八").promotable?(Location[:white]) == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      assert Dimension::Xplace.fetch("1") == Dimension::Xplace.fetch("一")
    end

    it "ソート" do
      assert [Dimension::Yplace.fetch("1"), Dimension::Yplace.fetch("2")].sort.collect(&:name) == ["２", "１"]
    end

    describe "5x5の盤面" do
      it do
        Board.dimensiton_change([5, 5]) do
          assert { Mediator.player_test.board.to_s == <<~EOT }
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
