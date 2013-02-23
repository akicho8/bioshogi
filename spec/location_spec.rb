# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Location do
    it do
      Location.parse(:black).name.should == "先手"
      Location[:black].name.should == "先手"
    end

    it "Enumerable対応" do
      Location.each.should be_present
    end

    it "手番を表すものが大量にあるので何でもパースできるようにしてある" do
      Location.to_a.last.match_target_values.should == [:white, "▽", "△", "後手", "後", 1]
      Location["△"].name.should == "後手"
      Location[1].name.should == "後手"
    end
  end
end
