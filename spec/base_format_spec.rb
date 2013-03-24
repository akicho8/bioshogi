# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe BaseFormat do
    it "座標がない場合は右上の盤面とする" do
      board_parse_test(<<-BOARD).should == {:white => ["1一歩"], :black => ["1二歩"]}
+------+
| ・v歩|
| ・ 歩|
+------+
BOARD
    end

    it "座標の指定があれば任意のエリアを表現できる" do
      board_parse_test(<<-BOARD).should == {:black => ["8九歩"], :white => ["8八歩"]}
  ９ ８
+------+
| ・v歩|八
| ・ 歩|九
+------+
BOARD
    end

    it "成駒を認識できる" do
      board_parse_test(<<-BOARD).should == {:black => [], :white => ["1一龍"]}
+---+
|v龍|
+---+
BOARD
    end

#     it "盤面サイズを変更していても定義は9x9を元にしているので問題なくパースできる" do
#       Board.size_change([2, 2]) do
#         p Point["３一"]
#
# #         board_parse_test(<<-BOARD).should == {:black => ["3一歩"], :white => []}
# # +---------+
# # | 歩 ・ ・|
# # +---------+
# # BOARD
#       end
#     end

    it "盤面の「・」は不要" do
      board_parse_test(<<-BOARD).should == {:white => ["1一歩"], :black => ["1二歩"]}
+------+
|   v歩|
|    歩|
+------+
BOARD
    end

    it "先手後手の表現" do
      board_parse_test("+---+\| 金|\n+---+").should == {:black => ["1一金"], :white => []}
      board_parse_test("+---+\|^金|\n+---+").should == {:black => ["1一金"], :white => []}
      board_parse_test("+---+\|v金|\n+---+").should == {:black => [],        :white => ["1一金"]}
    end

#     describe "あえて緩くしている部分" do
#       it "座標の名前のチェックなし" do
#         board_parse_test(<<-BOARD).should == {:black => ["AY歩"], :white => ["AX歩"]}
#   B  A
# +------+
# | ・v歩|X
# | ・ 歩|Y
# +------+
# BOARD
#       end
#     end

    describe "エラー" do
      it "駒がおかしい" do
        expect { board_parse_test("+---+\| ★|\n+---+") }.to raise_error(SyntaxError, /駒の指定が違う/)
      end

      it "横幅が3桁毎になっていない" do
        expect { board_parse_test(<<-BOARD) }.to raise_error(SyntaxError, /横幅が3桁毎になっていない/)
+--+
|歩|
+--+
BOARD
      end
    end
  end
end
