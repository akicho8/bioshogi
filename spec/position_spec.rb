# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Position do
    describe "座標パース" do
      it "エラー" do
        expect { Position::Hpos.parse("")  }.to raise_error(PositionSyntaxError)
        expect { Position::Hpos.parse(nil) }.to raise_error(PositionSyntaxError)
      end
      it "横" do
        Position::Hpos.parse("1").name.should == "1"
        Position::Hpos.parse("１").name.should == "1"
      end
      it "縦" do
        Position::Vpos.parse("一").name.should == "一"
        Position::Vpos.parse("1").name.should == "一"
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
      Position::Hpos.parse("1").reverse.name.should == "9"
    end

    it "数字表記" do
      Position::Vpos.parse("一").number_format.should == "1"
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
        @save_size = [Position::Hpos.ridge_length, Position::Vpos.ridge_length]
        Position::Hpos.ridge_length, Position::Vpos.ridge_length = [5, 5]
      end
      after do
        Position::Hpos.ridge_length, Position::Vpos.ridge_length = @save_size
      end
      it do
        player_test.board.to_s.should == <<-EOT.strip_heredoc
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
