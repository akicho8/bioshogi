# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    let(:field)  { Field.new }
    let(:player) { Player.new("先手", field, :kotti) }

    describe "#to_s" do
      subject { Soldier.new(player, Piece::Fu.new) }
      its(:to_s) { should == "歩" }
    end

    describe "#moveable_all_cells" do
      context "初期配置の場合" do
        before { player.setup }
        it { field.matrix[[2, 6]].moveable_all_cells.collect(&:to_xy).should == [[2, 5]] }                                         # 歩
        it { field.matrix[[0, 8]].moveable_all_cells.collect(&:to_xy).should == [[0, 7]] }                                         # 香
        it { field.matrix[[1, 8]].moveable_all_cells.collect(&:to_xy).should == [] }                                               # 桂
        it { field.matrix[[2, 8]].moveable_all_cells.collect(&:to_xy).should == [[2, 7], [3, 7]] }                                 # 銀
        it { field.matrix[[3, 8]].moveable_all_cells.collect(&:to_xy).should == [[2, 7], [3, 7], [4, 7]] }                         # 金
        it { field.matrix[[4, 8]].moveable_all_cells.collect(&:to_xy).should == [[3, 7], [4, 7], [5, 7]] }                         # 王
        it { field.matrix[[1, 7]].moveable_all_cells.collect(&:to_xy).should == [] }                                               # 角
        it { field.matrix[[7, 7]].moveable_all_cells.collect(&:to_xy).should == [[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [8, 7]] } # 飛
      end
      # context "初期配置の場合" do
      #   before { player.reset_field([{}]) }
      # end
    end
  end
end
