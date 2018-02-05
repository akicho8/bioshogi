require_relative "spec_helper"

module Warabi
  describe Position do
    describe "座標パース" do
      it "引数が根本的にダメなのでエラー" do
        expect { Position::Hpos.fetch("")  }.to raise_error(PositionSyntaxError)
        expect { Position::Hpos.fetch(nil) }.to raise_error(PositionSyntaxError)
      end
      it "横の範囲外" do
        expect { Board.size_change([2, 2]) { Position::Hpos.fetch("３") } }.to raise_error(PositionSyntaxError)
      end
      it "縦の範囲外" do
        expect { Board.size_change([2, 2]) { Position::Vpos.fetch("三")  } }.to raise_error(PositionSyntaxError)
      end

      describe "正常" do
        it "横" do
          Position::Hpos.fetch("1").name.should == "１"
          Position::Hpos.fetch("１").name.should == "１"
          Position::Hpos.fetch("一").name.should == "１"
        end

        it "縦" do
          Position::Vpos.fetch("1").name.should == "一"
          Position::Vpos.fetch("１").name.should == "一"
          Position::Vpos.fetch("一").name.should == "一"
        end
      end
    end

    it "座標の幅" do
      Position::Hpos.value_range.to_s.should == "0...9"
    end

    describe "バリデーション" do
      it "正しい座標" do
        Position::Hpos.fetch(0).valid?.should == true
      end
      it "間違った座標" do
        Position::Hpos.fetch(-1).valid?.should == false
      end
    end

    it "座標反転" do
      Position::Hpos.fetch("１").reverse.name.should == "９"
    end

    it "数字表記" do
      Position::Vpos.fetch("一").number_format.should == "1"
    end

    it "全角数字表記" do
      Position::Vpos.fetch("９").number_format.should == "9"
    end

    it "成れるか？" do
      Position::Vpos.fetch("二").promotable?(Location[:black]).should == true
      Position::Vpos.fetch("三").promotable?(Location[:black]).should == true
      Position::Vpos.fetch("四").promotable?(Location[:black]).should == false
      Position::Vpos.fetch("六").promotable?(Location[:white]).should == false
      Position::Vpos.fetch("七").promotable?(Location[:white]).should == true
      Position::Vpos.fetch("八").promotable?(Location[:white]).should == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      Position::Vpos.fetch("1").should == Position::Vpos.fetch("一")
    end

    it "ソート" do
      [Position::Hpos.fetch("1"), Position::Hpos.fetch("2")].sort.collect(&:name).should == ["２", "１"]
    end

    describe "5x5の盤面" do
      it do
        Board.size_change([5, 5]) do
          player_test.board.to_s.should == <<~EOT
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
