# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Ki2Format do
    context "ki2読み込み" do
      before do
        file = Pathname(__FILE__).dirname.join("sample1.ki2").expand_path
        @result = Ki2Format::Parser.parse(file.read)
      end

      it "ヘッダー部" do
        @result.header.should == {"開始日時" => "2000/01/01 00:00", "終了日時" => "2000/01/01 01:00", "表題" => "(表題)", "棋戦" => "(棋戦)", "戦型" => "(戦型)", "持ち時間" => "(持ち時間)", "場所" => "(場所)", "掲載" => "(掲載)", "立会人" => "(立会人)", "副立会人" => "(副立会人)", "記録係" => "(記録係)", "Web Page" => "(Web Page)", "通算成績" => "(通算成績)", "先手" => "(先手)", "後手" => "(後手)"}
      end

      it "棋譜の羅列" do
        @result.move_infos.should == [
          {:input => "７六歩"},
          {:input => "３四歩", :comments => ["コメント1"]},
          {:input => "６六歩"},
          {:input => "８四歩", :comments => ["コメント2"]},
        ]
      end

      it "対局前コメント" do
        @result.first_comments.should == ["対局前コメント"]
      end
    end

    context "読み込み練習" do
      it do
        result = Ki2Format::Parser.parse(Pathname(__FILE__).dirname.join("../resources/竜王戦_ki2/龍王戦2002-15 羽生阿部-3.ki2").read)
        # result.tapp
      end
    end
  end
end
