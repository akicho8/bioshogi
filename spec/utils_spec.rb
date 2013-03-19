# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Utils do
    it "文字列の分解" do
      Utils.parse_str("４二竜").should == {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
    end

    it "棋譜入力の分離" do
      Utils.ki2_input_seq_parse("▲５五歩△４四歩 push ▲３三歩 pop").should == [{:location => :black, :input => "５五歩"}, {:location => :white, :input => "４四歩"}, "push", {:location => :black, :input => "３三歩"}, "pop"]
    end

    describe "持駒表記変換" do
      it "人間表記 → コード" do
        Utils.stand_unpack("歩2 飛").should == [Piece["歩"], Piece["歩"], Piece["飛"]]
      end

      it "コード → 人間表記" do
        Utils.stand_pack([Piece["歩"], Piece["歩"], Piece["飛"]]).should == "歩二 飛"
      end
    end

    it "先手か後手かを指定した初期配置" do
      Utils.initial_placements_for(:white, "平手")
      Utils.initial_placements_for(:white, "角落ち")
    end
  end
end
