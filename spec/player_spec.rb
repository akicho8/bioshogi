# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Soldier do
    let(:field)  { Field.new }
    let(:player) { Player.new("先手", field, :lower) }

    describe "#init_soldiers" do
      it do
        player.init_soldier("5三歩成")
        player.soldiers.collect(&:to_text).should == ["▲5三成歩"]
      end
    end
  end
end
