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
          Dimension::Yplace.fetch("1").name.should == "１"
          Dimension::Yplace.fetch("１").name.should == "１"
          Dimension::Yplace.fetch("一").name.should == "１"
        end

        it "縦" do
          Dimension::Xplace.fetch("1").name.should == "一"
          Dimension::Xplace.fetch("１").name.should == "一"
          Dimension::Xplace.fetch("一").name.should == "一"
        end
      end
    end

    it "座標の幅" do
      Dimension::Yplace.value_range.to_s.should == "0...9"
    end

    describe "バリデーション" do
      it "正しい座標" do
        Dimension::Yplace.fetch(0).valid?.should == true
      end
      it "間違った座標" do
        Dimension::Yplace.fetch(-1).valid?.should == false
      end
    end

    it "座標反転" do
      Dimension::Yplace.fetch("１").flip.name.should == "９"
    end

    it "数字表記" do
      Dimension::Xplace.fetch("一").number_format.should == "1"
    end

    it "全角数字表記" do
      Dimension::Xplace.fetch("９").number_format.should == "9"
    end

    it "成れるか？" do
      Dimension::Xplace.fetch("二").promotable?(Location[:black]).should == true
      Dimension::Xplace.fetch("三").promotable?(Location[:black]).should == true
      Dimension::Xplace.fetch("四").promotable?(Location[:black]).should == false
      Dimension::Xplace.fetch("六").promotable?(Location[:white]).should == false
      Dimension::Xplace.fetch("七").promotable?(Location[:white]).should == true
      Dimension::Xplace.fetch("八").promotable?(Location[:white]).should == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      Dimension::Xplace.fetch("1").should == Dimension::Xplace.fetch("一")
    end

    it "ソート" do
      [Dimension::Yplace.fetch("1"), Dimension::Yplace.fetch("2")].sort.collect(&:name).should == ["２", "１"]
    end

    describe "5x5の盤面" do
      it do
        Board.dimensiton_change([5, 5]) do
          Mediator.player_test.board.to_s.should == <<~EOT
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
# ~> -:1:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:1:in `<main>'
