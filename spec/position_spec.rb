require_relative "spec_helper"

module Bushido
  describe Position do
    describe "座標パース" do
      it "引数が根本的にダメなのでエラー" do
        expect { Position::Hpos.parse("")  }.to raise_error(PositionSyntaxError)
        expect { Position::Hpos.parse(nil) }.to raise_error(PositionSyntaxError)
      end
      it "横の範囲外" do
        expect { Board.size_change([2, 2]) { Position::Hpos.parse("３") } }.to raise_error(PositionSyntaxError)
      end
      it "縦の範囲外" do
        expect { Board.size_change([2, 2]) { Position::Vpos.parse("三")  } }.to raise_error(PositionSyntaxError)
      end

      describe "正常" do
        it "横" do
          Position::Hpos.parse("1").name.should == "１"
          Position::Hpos.parse("１").name.should == "１"
          Position::Hpos.parse("一").name.should == "１"
        end

        it "縦" do
          Position::Vpos.parse("1").name.should == "一"
          Position::Vpos.parse("１").name.should == "一"
          Position::Vpos.parse("一").name.should == "一"
        end
      end
    end

    it "座標の幅" do
      Position::Hpos.value_range.to_s.should == "0...9"
    end

    describe "バリデーション" do
      it "正しい座標" do
        Position::Hpos.parse(0).valid?.should == true
      end
      it "間違った座標" do
        Position::Hpos.parse(-1).valid?.should == false
      end
    end

    it "座標反転" do
      Position::Hpos.parse("１").reverse.name.should == "９"
    end

    it "数字表記" do
      Position::Vpos.parse("一").number_format.should == "1"
    end

    it "全角数字表記" do
      Position::Vpos.parse("９").number_format.should == "9"
    end

    it "成れるか？" do
      Position::Vpos.parse("二").promotable?(Location[:black]).should == true
      Position::Vpos.parse("三").promotable?(Location[:black]).should == true
      Position::Vpos.parse("四").promotable?(Location[:black]).should == false
      Position::Vpos.parse("六").promotable?(Location[:white]).should == false
      Position::Vpos.parse("七").promotable?(Location[:white]).should == true
      Position::Vpos.parse("八").promotable?(Location[:white]).should == true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      Position::Vpos.parse("1").should == Position::Vpos.parse("一")
    end

    describe "5x5の盤面" do
      before do
        @save_size = [Position::Hpos.size, Position::Vpos.size]
        Position::Hpos.size, Position::Vpos.size = [5, 5]
      end
      after do
        Position::Hpos.size, Position::Vpos.size = @save_size
      end
      it do
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
