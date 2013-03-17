# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe BaseFormat do
    it "座標がない場合は右上の盤面とする" do
      BaseFormat.board_parse(<<-BOARD).should == {:white => ["１一歩"], :black => ["１二歩"]}
+------+
| ・v歩|
| ・ 歩|
+------+
BOARD
    end

    it "座標の指定があれば任意のエリアを表現できる" do
      BaseFormat.board_parse(<<-BOARD).should == {:black => ["８九歩"], :white => ["８八歩"]}
  ９ ８
+------+
| ・v歩|八
| ・ 歩|九
+------+
BOARD
    end

    it "盤面の「・」は不要" do
      BaseFormat.board_parse(<<-BOARD).should == {:white => ["１一歩"], :black => ["１二歩"]}
+------+
|   v歩|
|    歩|
+------+
BOARD
    end

    it "先手後手の表現" do
      BaseFormat.board_parse("+---+\| 金|\n+---+").should == {:black => ["１一金"], :white => []}
      BaseFormat.board_parse("+---+\|^金|\n+---+").should == {:black => ["１一金"], :white => []}
      BaseFormat.board_parse("+---+\|v金|\n+---+").should == {:black => [],         :white => ["１一金"]}
    end

    context "あえて緩くしている部分" do
      it "駒のチェックなし" do
        BaseFormat.board_parse("+---+\| ★|\n+---+").should == {:black => ["１一★"], :white => []}
      end

      it "座標の名前のチェックなし" do
        BaseFormat.board_parse(<<-BOARD).should == {:black => ["AY歩"], :white => ["AX歩"]}
  B  A
+------+
| ・v歩|X
| ・ 歩|Y
+------+
BOARD
      end
    end
  end
end
