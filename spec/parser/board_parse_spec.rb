require_relative "../spec_helper"

module Bushido
  describe "盤面の読み取り" do
    def test1(source)
      BoardParser.parse(source).soldiers.collect(&:name).sort
    end

    describe "縦横軸の数字" do
      it "なくてもいい" do
        test1(<<-EOT).should == ["▲１二歩", "△１一歩"]
+------+
| ・v歩|
| ・ 歩|
+------+
EOT
      end

      it "あると任意の位置とみなす" do
        test1(<<-EOT).should == ["▲８九歩", "△８八歩"]
  ９ ８
+------+
| ・v歩|八
| ・ 歩|九
+------+
EOT
      end
    end

    it "コメント" do
      test1(<<-EOT).should == ["▲１一歩"]
+---+
| 歩| # コメント
+---+
EOT
      end
    
    it "成駒を認識" do
      test1(<<-EOT).should == ["△１一龍"]
+---+
|v龍|
+---+
EOT
    end

    it "盤面サイズを変更していてもパースできる" do
      Board.size_change([2, 2]) do
        test1(<<-EOT).should == ["▲２一歩"]
+------+
| 歩 ・|
+------+
EOT
      end
    end

    it "盤面の「・」はなくてもいい" do
      test1(<<-EOT).should == ["▲１二歩", "△１一歩"]
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

    describe BoardParser::FireBoardParser do
      it "他の駒以外のものも拾える" do
        info = BoardParser::FireBoardParser.parse(<<~EOT)
+------+
|v○v歩|
| ・ 歩|
+------+
          EOT
        info.other_objects == [{point: Point["21"], location: Location[:white], something: "○"}]
      end
    end
  end
end
