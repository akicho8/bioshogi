require_relative "spec_helper"

module Warabi
  describe Utils do
    it "初期配置情報の塊を分離" do
      Utils.initial_battlers_split("▲４二銀 △４二銀").should == [{location: Location[:black], input: "４二銀"}, {location: Location[:white], input: "４二銀"}]
    end

    it "棋譜入力の分離(ゴミは保持)" do
      Utils.ki2_parse("▲５五歩△４四歩 push ▲３三歩 pop").should == [{location: Location[:black], input: "５五歩"}, {location: Location[:white], input: "４四歩"}, "push", {location: Location[:black], input: "３三歩"}, "pop"]
    end

    it "棋譜入力の分離(一つだけ)" do
      Utils.mov_split_one("▲５五歩").should == {location: Location[:black], input: "５五歩"}
    end

    describe "movs_split" do
      it "棋譜入力の分離(ゴミがあっても無視)" do
        Utils.movs_split("▲５五歩△４四歩 push ▲３三歩 pop").should == [{location: Location[:black], input: "５五歩"}, {location: Location[:white], input: "４四歩"}, {location: Location[:black], input: "３三歩"}]
      end
      it "先手後手がわからないと無視する" do
        Utils.movs_split("５五歩").should == []
      end
    end

    describe "初期配置" do
      before do
        @white_king = [Soldier.new(piece: Piece["玉"], promoted: false, point: Point["５一"], location: Location[:white])]
        @black_king = [Soldier.new(piece: Piece["玉"], promoted: false, point: Point["５九"], location: Location[:black])]
        @black_rook = [Soldier.new(piece: Piece["飛"], promoted: false, point: Point["１一"], location: Location[:black])]
      end

      it "先手か後手の一方用" do
        Soldier.location_soldiers(location: Location[:white], key: "十九枚落ち").should == @white_king
        Soldier.location_soldiers(location: Location[:black], key: "十九枚落ち").should == @black_king
      end

      #       describe "board_reset の3通りの引数を先手・後手をキーしたハッシュにする" do
      #         it "先手→十九枚落ち 後手→平手" do
      #           r = Utils.board_reset_args("十九枚落ち")
      #           r[Location[:black]].should == @black_king
      #           r[Location[:white]].should be_a Array # 平手
      #         end
      #
      #         it "先手→十九枚落ち 後手→十九枚落ち(DSL用)" do
      #           r = Utils.board_reset_args_hash("▲" => "十九枚落ち", "△" => "十九枚落ち")
      #           r[Location[:black]].should == @black_king
      #           r[Location[:white]].should == @white_king
      #         end
      #
      #         it "盤面指定" do
      #           r = Utils.board_reset_args(<<~EOT)
      #   ９ ８ ７ ６ ５ ４ ３ ２ １
      # +---------------------------+
      # | ・ ・ ・ ・v玉 ・ ・ ・ ・|一
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|二
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|三
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
      # | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
      # | ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
      # +---------------------------+
      # EOT
      #           r[Location[:black]].should == @black_king
      #           r[Location[:white]].should == @white_king
      #         end
      #       end
    end
  end
end
