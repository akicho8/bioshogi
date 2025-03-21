require "spec_helper"

  describe do
    def test1(str)
      container = Bioshogi::Container::Basic.new
      container.board.placement_from_shape(<<~EOT)
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・ ・v角|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・v角 ・ ・ ・v飛|
| ・ ・ ・ ・ ・ ・ ・ ・ ・|
|v金 ・ ・ ・ ・ ・ ・ ・ ・|
|v金 ・v金 ・ ・ ・ ・ ・ ・|
| ・ ・ ・ ・ ・ ・ ・ ・v飛|
+---------------------------+
        EOT
      container.next_player.execute(str)
      container.hand_logs.last.to_kif_ki2_csa
    end

    it "エラー" do
      expect { test1("１七飛成") }.to raise_error(Bioshogi::AmbiguousFormatError)
      expect { test1("３三角") }.to raise_error(Bioshogi::AmbiguousFormatError)
    end

    it "「上」は「行」と書ける" do
      assert { test1("１七飛上") == ["１七飛(15)", "１七飛上不成", "-1517HI"] }
      assert { test1("１七飛行") == ["１七飛(15)", "１七飛上不成", "-1517HI"] }

      assert { test1("３三角上") == ["３三角(11)", "３三角上", "-1133KA"] }
      assert { test1("３三角行") == ["３三角(11)", "３三角上", "-1133KA"] }
    end

    it "ただし大駒以外には使えない" do
      assert { test1("８八金右上") == ["８八金(97)", "８八金右上", "-9788KI"] }
      expect { test1("８八金右行") }.to raise_error(Bioshogi::AmbiguousFormatError)
    end
  end
