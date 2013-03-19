# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Board do
    it "サンプル" do
      board = Board.new
      board["５五"].must_equal nil
    end
  end
end
