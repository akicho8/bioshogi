# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe MiniSoldier do
    it do
      MiniSoldier[:piece => Piece["玉"], :promoted => false, :point => Point["５一"]].to_s.should == "5一玉"
    end
  end
end
