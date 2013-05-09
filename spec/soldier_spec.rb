# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    describe "文字列表現" do
      before do
        @soldier = player_test(init: "５五と").soldiers.first
      end
      it "先手後手のマーク付き" do
        @soldier.mark_with_formal_name.should == "▲5五と"
        @soldier.name.should == "▲5五と"
      end
      it "先手後手のマークなし" do
        @soldier.to_s_formal_name.should == "5五と"
      end
      it "駒のみ" do
        @soldier.piece_current_name.should == "と"
      end
      it "盤上に置いてない場合" do
        @soldier.point = nil
        @soldier.mark_with_formal_name.should == "▲(どこにも置いてない)と"
      end
    end

    it "#abone - 盤面の駒をなかったことにする(テスト用)" do
      Board.size_change([3, 3]) do
        player = player_test(init: "１一飛")
        soldier = player.board["１一"].abone
        player.board["１一"].should == nil # 盤面から消えている
        soldier.point.should == nil        # 盤上から削除した駒の座標は nil になっている
        player.soldiers.should == []       # プレイヤーから見た盤面上の駒にも含まれてない
      end
    end

    describe "#movable_infos" do
      it "移動可能な筋の取得(超重要なテスト)" do
        Board.size_change([1, 5]) do
          Mediator.test(init: "▲１五香").board["１五"].movable_infos.collect(&:to_s).should == ["1四香", "1三香", "1三杏", "1二香", "1二杏", "1一杏"]
          Mediator.test(init: "▲１五杏").board["１五"].movable_infos.collect(&:to_s).should == ["1四杏"]
        end
      end

      it "成るパターンと成らないパターンがある。相手の駒があるのでそれ以上進めない" do
        Board.size_change([1, 5]) do
          Mediator.test(init: "▲１五香 △１三歩").board["１五"].movable_infos.collect(&:to_s).should == ["1四香", "1三香", "1三杏"]
        end
      end

      it "初期配置での移動可能な座標" do
        player = player_test(run_piece_plot: true)
        player.board["7七"].movable_infos.collect(&:to_s).should == ["7六歩"]                                              # 歩
        player.board["9九"].movable_infos.collect(&:to_s).should == ["9八香"]                                              # 香
        player.board["8九"].movable_infos.collect(&:to_s).should == []                                                     # 桂
        player.board["7九"].movable_infos.collect(&:to_s).should == ["7八銀", "6八銀"]                                     # 銀
        player.board["6九"].movable_infos.collect(&:to_s).should == ["7八金", "6八金", "5八金"]                            # 金
        player.board["5九"].movable_infos.collect(&:to_s).should == ["6八玉", "5八玉", "4八玉"]                            # 玉
        player.board["8八"].movable_infos.collect(&:to_s).should == []                                                     # 角
        player.board["2八"].movable_infos.collect(&:to_s).should == ["3八飛", "4八飛", "5八飛", "6八飛", "7八飛", "1八飛"] # 飛
      end
    end
  end
end
