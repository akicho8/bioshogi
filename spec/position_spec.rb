# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Position do
    it "座標をパースする" do
      Position::Hpos.parse("1").name.should == "1"
      Position::Hpos.parse("１").name.should == "1"
    end
  end
end
