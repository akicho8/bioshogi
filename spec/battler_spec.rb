require_relative "spec_helper"

module Warabi
  describe Battler do
    describe "文字列表現" do
      before do
        @battler = player_test(init: "５五と").battlers.first
      end
      it "先手後手のマーク付き" do
        @battler.name.should == "▲５五と"
        @battler.name.should == "▲５五と"
      end
      it "先手後手のマークなし" do
        @battler.name_without_location.should == "５五と"
      end
      it "駒のみ" do
        @battler.any_name.should == "と"
      end
      # it "盤上に置いてない場合" do
      #   @battler.point = nil
      #   @battler.name.should == "▲(どこにも置いてない)と"
      # end
    end

    it "#abone - 盤面の駒をなかったことにする(テスト用)" do
      Board.size_change([3, 3]) do
        player = player_test(init: "▲１一飛")
        battler = player.board.abone_on(Point["１一"])
        player.board["１一"].should == nil # 盤面から消えている
        # battler.point.should == nil        # 盤上から削除した駒の座標は nil になっている
        player.battlers.should == []       # プレイヤーから見た盤面上の駒にも含まれてない
      end
    end

    describe "#movable_infos" do
      it "移動可能な筋の取得(超重要なテスト)" do
        Board.size_change([1, 5]) do
          Mediator.test(init: "▲１五香").board["１五"].movable_infos.collect(&:name).should == ["▲１四香", "▲１三香", "▲１三杏", "▲１二香", "▲１二杏", "▲１一杏"]
          Mediator.test(init: "▲１五杏").board["１五"].movable_infos.collect(&:name).should == ["▲１四杏"]
        end
      end

      it "成るパターンと成らないパターンがある。相手の駒があるのでそれ以上進めない" do
        Board.size_change([1, 5]) do
          Mediator.test(init: "▲１五香 △１三歩").board["１五"].movable_infos.collect(&:name).should == ["▲１四香", "▲１三香", "▲１三杏"]
        end
      end

      it "初期配置での移動可能な座標" do
        player = player_test(run_piece_plot: true)
        player.board["７七"].movable_infos.collect(&:name).should == ["▲７六歩"]                                                             # 歩
        player.board["９九"].movable_infos.collect(&:name).should == ["▲９八香"]                                                             # 香
        player.board["８九"].movable_infos.collect(&:name).should == []                                                                       # 桂
        player.board["７九"].movable_infos.collect(&:name).should == ["▲７八銀", "▲６八銀"]                                                 # 銀
        player.board["６九"].movable_infos.collect(&:name).should == ["▲７八金", "▲６八金", "▲５八金"]                                     # 金
        player.board["５九"].movable_infos.collect(&:name).should == ["▲６八玉", "▲５八玉", "▲４八玉"]                                     # 玉
        player.board["８八"].movable_infos.collect(&:name).should == []                                                                       # 角
        player.board["２八"].movable_infos.collect(&:name).should == ["▲３八飛", "▲４八飛", "▲５八飛", "▲６八飛", "▲７八飛", "▲１八飛"] # 飛
      end
    end
  end
end
