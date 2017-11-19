require_relative "spec_helper"

module Bushido
  describe Utils do
    it "初期配置情報の塊を分離" do
      Utils.initial_soldiers_split("▲４二銀 △４二銀").should == [{location: L.b, input: "４二銀"}, {location: L.w, input: "４二銀"}]
    end

    it "座標と駒の分解" do
      MiniSoldier.from_str("４二銀").should == {point: Point["４二"], piece: Piece["銀"], promoted: false}
      MiniSoldier.from_str("４二竜").should == {point: Point["４二"], piece: Piece["飛"], promoted: true}
    end

    it "棋譜入力の分離(ゴミは保持)" do
      Utils.ki2_parse("▲５五歩△４四歩 push ▲３三歩 pop").should == [{location: L.b, input: "５五歩"}, {location: L.w, input: "４四歩"}, "push", {location: L.b, input: "３三歩"}, "pop"]
    end

    it "棋譜入力の分離(一つだけ)" do
      Utils.mov_split_one("▲５五歩").should == {location: L.b, input: "５五歩"}
    end

    describe "movs_split" do
      it "棋譜入力の分離(ゴミがあっても無視)" do
        Utils.movs_split("▲５五歩△４四歩 push ▲３三歩 pop").should == [{location: L.b, input: "５五歩"}, {location: L.w, input: "４四歩"}, {location: L.b, input: "３三歩"}]
      end
      it "先手後手がわからないと無視する" do
        Utils.movs_split("５五歩").should == []
      end
    end

    describe "持駒表記変換" do
      before { @pieces = [Piece["歩"], Piece["歩"], Piece["飛"]] }

      describe "プレイヤーのスコープ" do
        it "人間表記 → コード" do
          Utils.hold_pieces_s_to_a("歩2 飛").should    == @pieces
          Utils.hold_pieces_s_to_a("歩二 飛").should   == @pieces
          Utils.hold_pieces_s_to_a("歩二飛").should    == @pieces
          Utils.hold_pieces_s_to_a(" 歩二 飛 ").should == @pieces
          Utils.hold_pieces_s_to_a(" 歩 二飛 ").should_not == @pieces
        end
        it "コード → 人間表記" do
          Utils.hold_pieces_a_to_s(@pieces).should == "歩二 飛"
        end
      end

      describe "全体スコープ" do
        before { @hash = {L.b => "歩2 飛 金", L.w => "歩二飛 "} }
        it "人間表記 → コード" do
          Utils.triangle_hold_pieces_str_to_hash("▲歩2 飛 △歩二飛 ▲金").should == @hash
        end
        it "コード → 表記" do
          Utils.triangle_hold_pieces_hash_to_str(@hash).should == "▲歩2 飛 金 ▽歩二飛 "
        end
      end
    end

    describe "初期配置" do
      before do
        @white_king = [MiniSoldier[piece: Piece["玉"], point: Point["５一"], promoted: false]]
        @black_king = [MiniSoldier[piece: Piece["玉"], point: Point["５九"], promoted: false]]
        @black_rook = [MiniSoldier[piece: Piece["飛"], point: Point["１一"], promoted: false]]
      end

      it "先手か後手の一方用" do
        Utils.location_soldiers(location: L.w, key: "裸玉").should == @white_king
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
