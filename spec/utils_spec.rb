# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Utils do
    it "文字列の分解" do
      Utils.parse_str("４二竜").should == {:point => Point["４二"], :piece => Piece["竜"], :promoted => true}
    end

    it "初期配置" do
      Utils.initial_placements_for(:white).should be_present
    end
  end
end
