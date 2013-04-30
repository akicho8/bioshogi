# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Utils do
    it "文字列の分解" do
      MiniSoldier.from_str("４二竜").should == {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
    end

    it "棋譜入力の分離(ゴミは保持)" do
      Utils.ki2_parse("▲５五歩△４四歩 push ▲３三歩 pop").should == [{:location => L.b, :input => "５五歩"}, {:location => L.w, :input => "４四歩"}, "push", {:location => L.b, :input => "３三歩"}, "pop"]
    end

    describe "mov_split" do
      it "棋譜入力の分離(ゴミがあっても無視)" do
        Utils.mov_split("▲５五歩△４四歩 push ▲３三歩 pop").should == [{:location => L.b, :input => "５五歩"}, {:location => L.w, :input => "４四歩"}, {:location => L.b, :input => "３三歩"}]
      end
      it "先手後手がわからないと無視する" do
        Utils.mov_split("５五歩").should == []
      end
    end

    describe "持駒表記変換" do
      it "人間表記 → コード" do
        Utils.stand_unpack("歩2 飛").should == [Piece["歩"], Piece["歩"], Piece["飛"]]
      end

      it "コード → 人間表記" do
        Utils.stand_pack([Piece["歩"], Piece["歩"], Piece["飛"]]).should == "歩二 飛"
      end
    end

    describe "初期配置" do
      before do
        @white_king = [MiniSoldier[:piece => Piece["玉"], :point => Point["５一"]]]
        @black_king = [MiniSoldier[:piece => Piece["玉"], :point => Point["５九"]]]
        @black_rook = [MiniSoldier[:piece => Piece["飛"], :point => Point["１一"]]]
      end

      it "先手か後手の一方用" do
        Utils.location_soldiers(:location => L.w, :key => "裸玉").should == @white_king
      end

      describe "board_reset の3通りの引数を先手・後手をキーしたハッシュにする" do
        it "先手→裸玉 後手→平手" do
          r = Utils.board_reset_args("裸玉")
          r[L.b].should == @black_king
          r[L.w].should be_a Array # 平手
        end

        it "先手→裸玉 後手→裸玉" do
          r = Utils.board_reset_args("先手" => "裸玉", "後手" => "裸玉")
          r[L.b].should == @black_king
          r[L.w].should == @white_king
        end

        it "先手は１一の飛車のみ" do
          r = Utils.board_reset_args(board_one_cell(" 飛"))
          r[L.b].should == @black_rook
          r[L.w].should be_a Array
        end
      end
    end
  end
end
