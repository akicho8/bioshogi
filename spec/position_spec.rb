# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Position do
    describe "座標パース" do
      it "エラー" do
        proc { Position::Hpos.parse("")  }.must_raise PositionSyntaxError
        proc { Position::Hpos.parse(nil) }.must_raise PositionSyntaxError
      end
      it "横" do
        Position::Hpos.parse("1").name.must_equal "1"
        Position::Hpos.parse("１").name.must_equal "1"
      end
      it "縦" do
        Position::Vpos.parse("一").name.must_equal "一"
        Position::Vpos.parse("1").name.must_equal "一"
      end
    end

    it "座標の幅" do
      Position::Hpos.value_range.to_s.must_equal "0...9"
    end

    describe "バリデーション" do
      it "正しい座標" do
        Position::Hpos.parse(0).valid?.must_equal true
      end
      it "間違った座標" do
        Position::Hpos.parse(-1).valid?.must_equal false
      end
    end

    it "座標反転" do
      Position::Hpos.parse("1").reverse.name.must_equal "9"
    end

    it "数字表記" do
      Position::Vpos.parse("一").number_format.must_equal "1"
    end

    it "成れるか？" do
      Position::Vpos.parse("二").promotable?(Location[:black]).must_equal true
      Position::Vpos.parse("三").promotable?(Location[:black]).must_equal true
      Position::Vpos.parse("四").promotable?(Location[:black]).must_equal false
      Position::Vpos.parse("六").promotable?(Location[:white]).must_equal false
      Position::Vpos.parse("七").promotable?(Location[:white]).must_equal true
      Position::Vpos.parse("八").promotable?(Location[:white]).must_equal true
    end

    it "インスタンスが異なっても同じ座標なら同じ" do
      Position::Vpos.parse("1").must_equal Position::Vpos.parse("一")
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
        player_test.board.to_s.must_equal <<-EOT.strip_heredoc
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
