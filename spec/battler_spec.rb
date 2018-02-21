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
      Board.dimensiton_change([3, 3]) do
        player = Mediator.player_test(init: "▲１一飛")
        soldier = player.board.safe_delete_on(Point["１一"])
        player.board["１一"].should == nil # 盤面から消えている
        # soldier.point.should == nil        # 盤上から削除した駒の座標は nil になっている
        player.soldiers.should == []       # プレイヤーから見た盤面上の駒にも含まれてない
      end
    end
  end
end
