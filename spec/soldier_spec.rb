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
      it do
        player.setup
        soldier = field.matrix[[2, 6]]
        soldier.moveable_all_cells.should == [[2, 5]]
      end
    end
  end
end
