require "spec_helper"

module Bioshogi
  describe "盤面の読み取り" do
    def test1(source)
      BoardParser.parse(source).soldiers.collect(&:name).sort
    end

    describe "縦横軸の数字" do
      it "なくてもいい" do
        assert { test1(<<-EOT) == ["▲１二歩", "△１一歩"] }
+------+
| ・v歩|
| ・ 歩|
+------+
EOT
      end

      it "あると任意の位置とみなす" do
        assert { test1(<<-EOT) == ["▲８九歩", "△８八歩"] }
  ９ ８
+------+
| ・v歩|八
| ・ 歩|九
+------+
EOT
      end
    end

    it "コメント" do
      assert { test1(<<-EOT) == ["▲１一歩"] }
+---+
| 歩| # コメント
+---+
EOT
      end

    it "成駒を認識" do
      assert { test1(<<-EOT) == ["△１一龍"] }
+---+
|v龍|
+---+
EOT
    end

    it "盤面サイズを変更していてもパースできる" do
      Dimension.wh_change([2, 2]) do
        assert { test1(<<-EOT) == ["▲２一歩"] }
+------+
| 歩 ・|
+------+
EOT
      end
    end

    it "盤面の「・」はなくてもいい" do
      assert { test1(<<-EOT) == ["▲１二歩", "△１一歩"] }
+------+
|   v歩|
|    歩|
+------+
EOT
    end

    describe "エラー" do
      it "横幅が3桁毎になっていません" do
        expect { test1(<<-EOT) }.to raise_error(SyntaxDefact, /横幅が3桁毎になっていません/)
+--+
|歩|
+--+
EOT
      end

      it "はみ出ている" do
        expect { test1(<<-EOT) }.to raise_error(SyntaxDefact, /はみ出ている/)
+---+
|v歩v歩|
+---+
EOT
      end
    end
  end
end
