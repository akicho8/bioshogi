# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe MiniSoldier do
    it ".from_str" do
      MiniSoldier.from_str("５一玉").to_s.should == "5一玉"
    end

    it "#to_s" do
      MiniSoldier[:point => Point["５一"], :piece => Piece["玉"]].to_s.should == "5一玉"
    end
  end
end
