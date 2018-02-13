require_relative "spec_helper"

module Warabi
  describe Soldier do
    describe "文字列表現" do
      before do
        @soldier = Mediator.player_test(init: "５五と").soldiers.first
      end
      it "先手後手のマーク付き" do
        @soldier.name.should == "▲５五と"
        @soldier.name.should == "▲５五と"
      end
      it "先手後手のマークなし" do
        @soldier.name_without_location.should == "５五と"
      end
      it "駒のみ" do
        @soldier.any_name.should == "と"
      end
      # it "盤上に置いてない場合" do
      #   @soldier.point = nil
      #   @soldier.name.should == "▲(どこにも置いてない)と"
      # end
    end

    it "#abone - 盤面の駒をなかったことにする(テスト用)" do
      Board.size_change([3, 3]) do
        player = Mediator.player_test(init: "▲１一飛")
        soldier = player.board.delete_on(Point["１一"])
        player.board["１一"].should == nil # 盤面から消えている
        # soldier.point.should == nil        # 盤上から削除した駒の座標は nil になっている
        player.soldiers.should == []       # プレイヤーから見た盤面上の駒にも含まれてない
      end
    end

    describe "#move_list" do
      it "移動可能な筋の取得(超重要なテスト)" do
        Board.size_change([1, 5]) do
          test = -> s {
            soldier = Soldier.from_str(s)
            soldier.move_list(Board.new).collect(&:to_kif)
          }
          test["▲１五香"].should == ["▲１四香(15)", "▲１三香(15)", "▲１三香成(15)", "▲１二香(15)", "▲１二香成(15)", "▲１一香成(15)"]
          test["▲１五杏"].should == ["▲１四杏(15)"]
        end
      end

      it "成るパターンと成らないパターンがある。相手の駒があるのでそれ以上進めない" do
        Board.size_change([1, 5]) do
          mediator = Mediator.test1(init: "▲１五香 △１三歩")
          mediator.board["１五"].move_list(mediator.board).collect(&:to_kif).should == ["▲１四香(15)", "▲１三香(15)", "▲１三香成(15)"]
        end
      end

      it "初期配置での移動可能な座標" do
        mediator = Mediator.start
        test = -> point { mediator.board[point].move_list(mediator.board).collect(&:to_kif) }
        test["７七"].should == ["▲７六歩(77)"]                                                                                 # 歩
        test["９九"].should == ["▲９八香(99)"]                                                                                 # 香
        test["８九"].should == []                                                                                               # 桂
        test["７九"].should == ["▲７八銀(79)", "▲６八銀(79)"]                                                                 # 銀
        test["６九"].should == ["▲７八金(69)", "▲６八金(69)", "▲５八金(69)"]                                                 # 金
        test["５九"].should == ["▲６八玉(59)", "▲５八玉(59)", "▲４八玉(59)"]                                                 # 玉
        test["８八"].should == []                                                                                               # 角
        test["２八"].should == ["▲３八飛(28)", "▲４八飛(28)", "▲５八飛(28)", "▲６八飛(28)", "▲７八飛(28)", "▲１八飛(28)"] # 飛
      end
    end
  end
end
