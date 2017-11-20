require_relative "../spec_helper"

module Bushido
  describe "盤面の読み取り" do
    it "座標がない場合は右上の盤面とする" do
      board_parse_test(<<-BOARD).should == {Location[:white] => ["１一歩"], Location[:black] => ["１二歩"]}
+------+
| ・v歩|
| ・ 歩|
+------+
BOARD
    end

    it "座標の指定があれば任意のエリアを表現できる" do
      board_parse_test(<<-BOARD).should == {Location[:black] => ["８九歩"], Location[:white] => ["８八歩"]}
  ９ ８
+------+
| ・v歩|八
| ・ 歩|九
+------+
BOARD
    end

    it "成駒を認識できる" do
      board_parse_test(<<-BOARD).should == {Location[:black] => [], Location[:white] => ["１一龍"]}
+---+
|v龍|
+---+
BOARD
    end

#     it "盤面サイズを変更していても定義は9x9を元にしているので問題なくパースできる" do
#       Board.size_change([2, 2]) do
#         board_parse_test(<<-BOARD).should == {Location[:black] => ["３一歩"], Location[:white] => []}
# +---------+
# | 歩 ・ ・|
# +---------+
# BOARD
#       end
#     end

    it "盤面の「・」は不要" do
      board_parse_test(<<-BOARD).should == {Location[:white] => ["１一歩"], Location[:black] => ["１二歩"]}
+------+
|   v歩|
|    歩|
+------+
BOARD
    end

    it "先手後手の表現" do
      board_parse_test("+---+\| 金|\n+---+").should == {Location[:black] => ["１一金"], Location[:white] => []}
      board_parse_test("+---+\|v金|\n+---+").should == {Location[:black] => [],         Location[:white] => ["１一金"]}
    end

#     describe "あえて緩くしている部分" do
#       it "座標の名前のチェックなし" do
#         board_parse_test(<<-BOARD).should == {Location[:black] => ["AY歩"], Location[:white] => ["AX歩"]}
#   B  A
# +------+
# | ・v歩|X
# | ・ 歩|Y
# +------+
# BOARD
#       end
#     end

    describe "エラー" do
      it "横幅が3桁毎になっていません" do
        expect { board_parse_test(<<-BOARD) }.to raise_error(SyntaxDefact, /横幅が3桁毎になっていません/)
+--+
|歩|
+--+
BOARD
      end
    end
  end
end
