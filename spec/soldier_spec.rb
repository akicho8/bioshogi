# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    let(:field)  { Field.new }
    let(:player) { Player.new("先手", field, :lower) }

    describe "#to_s" do
      subject { Soldier.new(player, Piece::Pawn.new) }
      its(:to_s) { should == "歩" }
    end

    describe "#moveable_all_cells" do
      context "初期配置の場合" do
        before { player.setup }
        it { field.fetch(Point["7七"]).moveable_all_cells.collect(&:name).should == ["7六"] }                                    # 歩
        it { field.fetch(Point["9九"]).moveable_all_cells.collect(&:name).should == ["9八"] }                                    # 香
        it { field.fetch(Point["8九"]).moveable_all_cells.collect(&:name).should == [] }                                         # 桂
        it { field.fetch(Point["7九"]).moveable_all_cells.collect(&:name).should == ["7八", "6八"] }                             # 銀
        it { field.fetch(Point["6九"]).moveable_all_cells.collect(&:name).should == ["7八", "6八", "5八"] }                      # 金
        it { field.fetch(Point["5九"]).moveable_all_cells.collect(&:name).should == ["6八", "5八", "4八"] }                      # 玉
        it { field.fetch(Point["8八"]).moveable_all_cells.collect(&:name).should == [] }                                         # 角
        it { field.fetch(Point["2八"]).moveable_all_cells.collect(&:name).should == ["3八", "4八", "5八", "6八", "7八", "1八"] } # 飛
      end

      context "成っている場合" do
        before do
        end
        it do
          player.init_soldiers(["5三飛成"])
          field.fetch(Point["5三"]).moveable_all_cells.collect(&:name).should == ["6二", "5二", "4二", "6三", "4三", "6四", "5四", "4四", "5二", "5一", "6三", "7三", "8三", "9三", "4三", "3三", "2三", "1三", "5四", "5五", "5六", "5七", "5八", "5九"]
        end
      end
    end
  end
end
