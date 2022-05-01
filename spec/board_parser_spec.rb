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
      Board.dimensiton_change([2, 2]) do
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

    describe BoardParser::CompareBoardParser do
      it "他の駒以外のものも拾える" do
        info = BoardParser::CompareBoardParser.parse(<<~EOT)
+------+
|v○v歩|
| ・ 歩|
+------+
          EOT
        info.other_objects == [{place: Place["21"], location: Location[:white], something: "○"}]
      end

      id do
        board_parser = BoardParser::CompareBoardParser.parse(<<~EOT)
+------------+
| ・ ・ ★v香|
|!歩@歩?歩*歩|
+------------+
EOT

        assert board_parser.soldiers                      # => [<Bioshogi::Soldier "△１一香">, <Bioshogi::Soldier "▲３二歩">]
        assert board_parser.trigger_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
        assert board_parser.other_objects_hash_ary        # => {"★"=>[{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}]}
        assert board_parser.other_objects_hash            # => {"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}
        assert board_parser.any_exist_soldiers            # => [<Bioshogi::Soldier "△２二歩">, <Bioshogi::Soldier "▲１二歩">]
        assert board_parser.other_objects_loc_places_hash # => {:black=>{"★"=>{#<Bioshogi::Place ２一>=>{:place=>#<Bioshogi::Place ２一>, :prefix_char=>" ", :something=>"★"}}}, :white=>{"★"=>{#<Bioshogi::Place ８九>=>{:place=>#<Bioshogi::Place ８九>, :prefix_char=>" ", :something=>"★"}}}}
        assert board_parser.any_exist_soldiers            # => [<Bioshogi::Soldier "△２二歩">, <Bioshogi::Soldier "▲１二歩">]
        assert board_parser.primary_soldiers              # => [<Bioshogi::Soldier "▲４二歩">, <Bioshogi::Soldier "▲３二歩">]
      end
    end
  end
end
