require_relative "../spec_helper"

module Bushido
  describe Parser::Ki2Parser do
    it "棋譜部分のパース" do
      def parse_test(s)
        Parser::Ki2Parser.parse(s).move_infos.collect{|e|e[:mov]}.join(" ")
      end

      # ▲は見ていない
      parse_test("７六歩").should           == "▲７六歩"
      parse_test("▲７六歩").should         == "▲７六歩"
      parse_test("▲１一歩△２二歩").should == "▲１一歩 △２二歩"
      parse_test("△１一歩▲２二歩").should == "▲１一歩 △２二歩"
    end

    it "ヘッダーがなく、いきなり棋譜入力しているデータも読み取れる" do
      info = Parser::Ki2Parser.parse("▲７六歩")
      info.move_infos.should == [
        {location: L.b, input: "７六歩", mov: "▲７六歩"},
      ]
      info.header.should == {}
    end

    it "激指定跡道場4のクリップボード書き出し結果が読める" do
      info = Parser::Ki2Parser.parse_file("#{__dir__}/../files/激指定跡道場4のクリップボード書き出し結果.ki2")
      # puts info.to_ki2
      info.to_ki2.should == <<~EOT
手合割：平手

▲７六歩     △４二銀 ▲２六歩 △５四歩     ▲２五歩   △５三銀   ▲２四歩   △同　歩     ▲５六歩   △３二金
▲２四飛     △２三歩 ▲２八飛 △３一角     ▲５五歩   △同　歩   ▲同　角   △５四歩     ▲８八角   △８四歩
▲４八銀     △８五歩 ▲６八銀 △６二銀右上 ▲７八金   △７四歩   ▲６九玉   △６四銀     ▲５七銀右 △７五歩
▲同　歩     △同　銀 ▲６六銀 △８六歩     ▲７五銀   △同　角   ▲８六歩   △同　角     ▲８七歩   △３一角
▲７四歩     △９四歩 ▲５三歩 △同　角     ▲９六歩   △４一玉   ▲６六角   △７五銀     ▲４八角   △７三歩
▲同　歩成   △同　銀 ▲３六歩 △８六歩     ▲同　歩   △同　銀   ▲３七角   △８七銀不成 ▲８三歩   △７八銀成
▲同　玉     △８三飛 ▲８七歩 △６四角     ▲同　角   △同　歩   ▲５三銀   △８八歩     ▲７七桂   △７六歩
▲６三角     △３一玉 ▲８五桂 △６二銀     ▲同　銀成 △同　金   ▲７四角成 △５三飛     ▲４一銀   △２二玉
▲３二銀不成 △同　玉 ▲２四歩 △同　歩     ▲同　飛   △２三歩   ▲２八飛   △５五角     ▲４一銀   △２二玉
▲４六歩     △７七銀 ▲６九玉 △４六角     ▲３二金   △１二玉   ▲７七銀   △同　歩成   ▲２二金   △同　玉
▲３一銀     △同　玉 ▲３七桂 △６八金     ▲同　飛   △同　角成
まで106手で後手の勝ち
EOT
    end

    describe "ki2読み込み" do
      before do
        @result = Parser::Ki2Parser.parse(<<~EOT)
        開始日時：2000/01/01 00:00
        終了日時：2000/01/01 01:00
        表題：(表題)
        棋戦：(棋戦)
        戦型：(戦型)
        持ち時間：(持ち時間)
        場所：(場所)
        掲載：(掲載)
        立会人：(立会人)
        副立会人：(副立会人)
        記録係：(記録係)
        Web Page：(Web Page)
        通算成績：(通算成績)
        先手：(先手)
        後手：(後手)

        *対局前コメント
        ▲７六歩    △３四歩
        *コメント1
        ▲６六歩△８四歩
        *コメント2
        まで4手で後手の勝ち
        EOT
      end

      it "ヘッダー部" do
        @result.header.should == {
          "開始日時" => "2000/01/01 00:00:00",
          "終了日時" => "2000/01/01 01:00:00",
          "表題"     => "(表題)",
          "棋戦"     => "(棋戦)",
          "戦型"     => "(戦型)",
          "持ち時間" => "(持ち時間)",
          "場所"     => "(場所)",
          "掲載"     => "(掲載)",
          "立会人"   => "(立会人)",
          "副立会人" => "(副立会人)",
          "記録係"   => "(記録係)",
          "Web Page" => "(Web Page)",
          "通算成績" => "(通算成績)",
          "先手"     => "(先手)",
          "後手"     => "(後手)",
        }
      end

      it "棋譜の羅列" do
        @result.move_infos.should == [
          {location: L.b, input: "７六歩", mov: "▲７六歩"},
          {location: L.w, input: "３四歩", mov: "△３四歩", comments: ["コメント1"]},
          {location: L.b, input: "６六歩", mov: "▲６六歩"},
          {location: L.w, input: "８四歩", mov: "△８四歩", comments: ["コメント2"]},
        ]
      end

      it "対局前コメント" do
        @result.first_comments.should == ["対局前コメント"]
      end
    end

    describe "読み込み練習" do
      it do
        result = Parser::Ki2Parser.parse(Pathname(__FILE__).dirname.join("../../resources/竜王戦_ki2/龍王戦2002-15 羽生阿部-3.ki2").read)
        # result.tapp
      end
    end
  end
end
