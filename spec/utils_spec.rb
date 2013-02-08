# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Utils do
    it "文字列の分解" do
      Utils.parse_arg("４二竜").should == {:point => Point["４二"], :piece => Piece["竜"], :promoted => true, :options => ""}
    end

    it "初期配置" do
      Utils.first_placements2(:white).should be_present
    end
  end
end
