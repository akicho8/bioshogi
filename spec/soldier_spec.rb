# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    let(:board)  { Board.new }
    let(:player) { Player.new(:location => :black, :board => board, :deal => true) }
    let(:soldier) { Soldier.new(:player => player, :piece => Piece[:pawn]) }

    context "文字列表現" do
      it "先手後手のマーク付き" do
        Player.basic_test(:init => "５五と").soldiers.first.formality_name.should == "▲5五と"
        Player.basic_test(:init => "５五と").soldiers.first.name.should == "▲5五と"
      end
      it "先手後手のマークなし" do
        Player.basic_test(:init => "５五と").soldiers.first.formality_name2.should == "5五と"
      end
      it "駒のみ" do
        Player.basic_test(:init => "５五と").soldiers.first.piece_current_name.should == "と"
      end
      it "盤上に置いてない場合" do
        soldier.formality_name.should == "▲(どこにも置いてない)歩"
      end
    end

    describe "#moveable_points" do
      it "初期配置での移動可能な座標" do
        player.piece_plot
        board["7七"].moveable_points.collect(&:name).should == ["7六"]                                    # 歩
        board["9九"].moveable_points.collect(&:name).should == ["9八"]                                    # 香
        board["8九"].moveable_points.collect(&:name).should == []                                         # 桂
        board["7九"].moveable_points.collect(&:name).should == ["7八", "6八"]                             # 銀
        board["6九"].moveable_points.collect(&:name).should == ["7八", "6八", "5八"]                      # 金
        board["5九"].moveable_points.collect(&:name).should == ["6八", "5八", "4八"]                      # 玉
        board["8八"].moveable_points.collect(&:name).should == []                                         # 角
        board["2八"].moveable_points.collect(&:name).should == ["3八", "4八", "5八", "6八", "7八", "1八"] # 飛
      end

      it "成っている5三龍だけがあるときの筋" do
        player.initial_soldiers(["5三龍"])
        board["5三"].moveable_points.collect(&:name).sort.should == ["6二", "5二", "4二", "6三", "4三", "6四", "5四", "4四", "5一", "7三", "8三", "9三", "3三", "2三", "1三", "5五", "5六", "5七", "5八", "5九"].sort
      end
    end

    it "復元できるかテスト" do
      player.put_on_with_valid(Point.parse("５五"), soldier)
      soldier.formality_name.should == "▲5五歩"
      soldier = Marshal.load(Marshal.dump(soldier()))
      soldier.formality_name.should == "▲5五歩"
    end
  end
end
