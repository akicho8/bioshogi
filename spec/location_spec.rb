# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Location do
    it do
      Location.parse(:black).name.should == "先手"
      Location[:black].name.should == "先手"
    end
  end
end
