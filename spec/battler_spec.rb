require_relative "spec_helper"

module Warabi
  describe Soldier do
    describe "文字列表現" do
      before do
        @soldier = Mediator.player_test(init: "５五と").soldiers.first
      end

      it "先手後手のマーク付き" do
        assert { @soldier.name == "▲５五と" }
        assert { @soldier.name == "▲５五と" }
      end

      it "先手後手のマークなし" do
        assert { @soldier.name_without_location == "５五と" }
      end

      it "駒のみ" do
        assert { @soldier.any_name == "と" }
      end
      # it "盤上に置いてない場合" do
      #   @soldier.place = nil
      #   @soldier.name == "▲(どこにも置いてない)と" }
      # end
    end

    it "#abone - 盤面の駒をなかったことにする(テスト用)" do
      Board.dimensiton_change([3, 3]) do
        player = Mediator.player_test(init: "▲１一飛")
        soldier = player.board.safe_delete_on(Place["１一"])
        assert { player.board["１一"] == nil } # 盤面から消えている
        # assert { soldier.place == nil }      # 盤上から削除した駒の座標は nil になっている }
        assert { player.soldiers == []  }      # プレイヤーから見た盤面上の駒にも含まれてない
      end
    end
  end
end
