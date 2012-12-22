# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    let(:board)  { Board.new }
    let(:player) { Player.create2(:black, board) }

    describe "#to_s" do
      subject { Soldier.new(player, Piece::Pawn.new) }
      its(:to_s) { should == "歩" }
    end

    describe "#moveable_points" do
      context "初期配置での移動可能な座標" do
        before { player.setup }
        it { board["7七"].moveable_points.collect(&:name).should == ["7六"] }                                    # 歩
        it { board["9九"].moveable_points.collect(&:name).should == ["9八"] }                                    # 香
        it { board["8九"].moveable_points.collect(&:name).should == [] }                                         # 桂
        it { board["7九"].moveable_points.collect(&:name).should == ["7八", "6八"] }                             # 銀
        it { board["6九"].moveable_points.collect(&:name).should == ["7八", "6八", "5八"] }                      # 金
        it { board["5九"].moveable_points.collect(&:name).should == ["6八", "5八", "4八"] }                      # 玉
        it { board["8八"].moveable_points.collect(&:name).should == [] }                                         # 角
        it { board["2八"].moveable_points.collect(&:name).should == ["3八", "4八", "5八", "6八", "7八", "1八"] } # 飛
      end

      context "成っている5三龍だけがあるときの筋" do
        it do
          player.side_soldiers_put_on(["5三龍"])
          board["5三"].moveable_points.collect(&:name).sort.should == ["6二", "5二", "4二", "6三", "4三", "6四", "5四", "4四", "5一", "7三", "8三", "9三", "3三", "2三", "1三", "5五", "5六", "5七", "5八", "5九"].sort
        end
      end
    end
  end
end
